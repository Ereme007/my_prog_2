module Readers
    # using Dates, CSV, DataFrames, TOML #, FileUtils
    using JLD2
    @load "Algorithm_DTW/src/Templates/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
    """
    чтение hdr-файла заголовка
    """
    function readhdr(filepath::AbstractString)
    
        str = open(filepath, "r") do io
            len = stat(filepath).size
            bytes = Vector{UInt8}(undef, len)
            readbytes!(io, bytes, len)
            if bytes[1:3] == [0xEF, 0xBB, 0xBF] # проверка на UTF-8 BOM и пропуск
                bytes = bytes[4:end]
            end
            str = Array{Char}(bytes) |> x->String(x)
        end
        io = IOBuffer(str)
        lines = readlines(io) #, enc"windows-1251") # read and decode from windows-1251 to UTF-8 string
    
        lines = rstrip.(lines)
    
        delim = (' ', '\t')
        ln = split(lines[1], delim)
        num_ch, fs, lsb = parse(Int, ln[1]), parse(Float64, ln[2]), parse(Float64, ln[3])
        type = Int32
        # if (length(ln) > 3) # optional field
        #     type = string2datatype[ln[4]]
        # end
    
        ln = split(lines[2], delim)
        ibeg, iend = parse(Int, ln[1]), parse(Int, ln[2])
        timestart = parse(DateTime, ln[3])
    
        names = String.(split(lines[3], delim))
        lsbs = parse.(Float64, split(lines[4], delim))
        units = String.(split(lines[5], delim))
    
        if num_ch != length(names) # фикс, если в начале указано неверное кол-во каналов
            num_ch = length(names)
        end
    
        length(names) == length(lsbs) == length(units) || error("разное количество полей")
    
        return num_ch, fs, ibeg, iend, timestart, names, lsbs, units, type
    end
    
    """
    чтение bin-файла с каналами, рядом должен лежать hdr-файл
    """
    function readbin(filepath::AbstractString, range::Union{Nothing, UnitRange{Int}} = nothing)
        # защита от дурака
        fpath, ext = splitext(filepath)
        hdrpath = fpath * ".hdr"
        binpath = fpath * ".bin"
    
        num_ch, fs, _, _, timestart, names, lsbs, units, type = readhdr(hdrpath)
    
        offset = (range !== nothing) ? range.start - 1 : 0
    
        elsize = num_ch * sizeof(type)
        byteoffset = offset * elsize # 0-based
        maxlen = (filesize(binpath) - byteoffset) ÷ elsize # 0-based
        len = (range !== nothing) ? min(maxlen, length(range)) : maxlen
    
        if len <= 0
            data = Matrix{type}(undef, num_ch, 0)
        else
            data = Matrix{type}(undef, num_ch, len)
            open(binpath, "r") do io
                seek(io, byteoffset)
                read!(io, data)
            end
        end
    
        channels = [data[ch, :] .* lsbs[ch] for ch in 1:num_ch] |> Tuple # matrix -> vector of channel vectors
        sym_names = Symbol.(names) |> Tuple # column names: String -> Symbol
    
        named_channels = NamedTuple{sym_names}(channels)
        return named_channels, fs, timestart, units
    end
    
    # чтение комбинированного текстового формата, состоящего из хедера и данных
    function readevt(filepath::String)
        open(filepath, "r") do io
            # complex code to read some_data
            num_ch, fs, ibeg, iend, timestart, names, lsbs, units, type, types = readhdr(io)
        
            # будем читать строки до тех пор, пока не стречим разделитель хедера и данных
            while readline(io) !== "#"
            end
            #@show line = readline(io)
            #@show line !== "#"
        
            sym_names = Symbol.(names)
            #@show sym_names
            pairs = map(zip(sym_names, types)) do (k, v)
                k => v
            end
        
            data = CSV.File(io;
                header = sym_names,
                types = Dict(pairs),
                delim = '\t',
            ) |> columntable # named tuple of columns
        
            return data, fs, timestart, units
        end
    end
    
    # Читает реф разметку из таблицы (сведённые позиции и границы для каждого файла)
    mutable struct MarkupFields
        P_onset::Float64     
        P_end::Float64
        QRS_onset::Float64
        QRS_end::Float64
        T_end::Float64
        P_dur::Float64
        PQ_interval::Float64
        QRS_dur::Float64
        QT_interval::Float64
        shift::Float64
    
        function MarkupFields()
            new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        end
    
        function MarkupFields(ponset, pend, qrsonset, qrsend, tend, pdur, pqint, qrsdur, qtint, shift)
            new(ponset, pend, qrsonset, qrsend, tend, pdur, pqint, qrsdur, qtint, shift)
        end
    end
    
    function read_all_ref(path::String)
        table = CSV.read(path, DataFrame, delim = ';')
        len = size(table)[1]
        refmarkup = Dict{String, MarkupFields}()
        for i in 1:len
            row = table[i,:]
            P_onset = try row["P-Onset"] catch e row["Ponset"] end
            P_end = try row["P-End"] catch e row["Pend"] end
            QRS_onset = try row["Qrs-Onset"] catch e row["QrsOn"] end
            QRS_end = try row["Qrs-End"] catch e row["QrsOff"] end
            T_end = try row["T-End"] catch e row["Tend"] end
            P_dur = try row["P-duration"]/2 catch e row["P_dur"] end
            PQ_interval = try row["PQ-interval"]/2 catch e row["PR"] end
            QRS_dur = try row["QRS-duration"]/2 catch e row["QRS"] end
            QT_interval = try row["QT-interval"]/2 catch e row["QT"] end
            shift = try row["End"] - row["Onset"] + 1 catch e 1000 end
        
            refmarkup[row["File"]] = MarkupFields(P_onset, P_end, QRS_onset, QRS_end, T_end, P_dur, PQ_interval, QRS_dur, QT_interval, shift)
        end
    
        return refmarkup
    end
    
    function read_microbox_test(path::String)
        table = readtable("$path\\StdEcgPars.bin")
        # table = formatdata(table)
    
        QRS_onset = table[:timeQ] |> collect
        QRS_offset = table[:timeS] |> collect
        P_onset = table[:timePstart] |> collect
        T_offset = table[:timeTendmax] |> collect
    
        QRS_dur = QRS_offset.-QRS_onset 
        PQ_dur = QRS_onset.-P_onset        
        QT_dur = T_offset.-QRS_onset      
    
        testmarkup = map((a,b,c,d,e,f,g) -> MarkupFields(a, 0, b, c, d, 0, e, f, g, 0), P_onset, QRS_onset, QRS_offset, T_offset, PQ_dur, QRS_dur, QT_dur)
    
        return testmarkup
    end
    
    # Зачитывает директорию dir и возвращает массив всех уникальных имён файлов без расширения (на каждую пару бинарь-хедер возвращается одно имя)
    function getfileslist(dir::String)
        filelist = readdir(dir)
        allbinfiles = filter(x->endswith(lowercase(x), ".bin"), filelist)
        allbinfiles = map(x -> splitext(x)[1], allbinfiles)
        return allbinfiles
    end
    
    # Читаем темплейты из файла и преобразуем словарь в структуру темплейта
    function gettemplates(path_toml::String)
        str = read(path_toml, String)
        dict = TOML.parse(str)
        tmpl_dict = template_dict(dict)
    
        return tmpl_dict
    end
    
    function _read_ref(nr, reffile::String = Raw_CSE_Ref_Incart )
        df = CSV.read(reffile, DataFrame, delim = ';')
        #@info df
        row = df[nr, :]
    
        # 0-индексы (?)
        filename = row["File"]
        ibeg = row["Onset"] + 1
        iend = row["End"] + 1
        P_onset = row["P-Onset"] + 1
        P_offset = row["P-End"] + 1
        Qrs_onset = row["Qrs-Onset"] + 1
        Qrs_end = row["Qrs-End"] + 1
        T_end = row["T-End"] + 1
        P_dur = row["P-duration"]
        PQ_int = row["PQ-interval"]
        Qrs_dur = row["QRS-duration"]
        QT_int = row["QT-interval"]
        return (;
            filename,
            ibeg,
            iend,
            P_onset,
            P_offset,
            Qrs_onset,
            Qrs_end,
            T_end,
            P_dur,
            PQ_int,
            Qrs_dur,
            QT_int,
        )
    end


    #Raw_CSE_MA_Data_Base_Incart = raw"\\incart.local\FS\GUEST\Yuly\ГОСТ51\bin\CSE_MA"
    #Raw_CSE_MO_Data_Base_Incart = raw"\\incart.local\FS\GUEST\Yuly\ГОСТ51\bin\CSE_MO"
    #Raw_CTS_Data_Base_Incart = raw"\\incart.local\FS\GUEST\Yuly\ГОСТ51\bin\CTS"
    #Raw_CSE_Ref_Incart = raw"\\incart.local\FS\GUEST\Yuly\ГОСТ51\CSE\ref.csv"
    #Raw_CTS_Ref_Incart = raw"\\incart.local\FS\GUEST\Yuly\ГОСТ51\CTS\ref.csv"


    Raw_CSE_MA_Data_Base_Incart = raw"C:\Local_Host\DataBase\CSE_MA"
    Raw_CSE_MO_Data_Base_Incart = raw"C:\Local_Host\DataBase\CSE_MO"
    Raw_CTS_Data_Base_Incart = raw"C:\Local_Host\DataBase\CTS"
    Raw_CSE_Ref_Incart = raw"C:\Local_Host\ref\CSE\ref.csv"
    Raw_CTS_Ref_Incart = raw"C:\Local_Host\ref\CTS\ref.csv"    
    
    using CSV, DataFrames, Dates
    
    #Главная функция 
    #Сигналс характиристиками 
    #Вход: Наименование базы данных(BaseName), номер (N)
    #Выход: Имя, сигнал, частота, коефф, референтная разметка qrs, референтная разметка p
    function Signal_all_channels(BaseName, N)
        #Сигнал (имя, сигнал, частота, вся референтная рамзетка)
        Names_files, Signal, Frequency, Ref_File = Read_Signal(BaseName, N)
        Const = map(copy, Signal)
        #_, Const, _, _ = Read_Signal(BaseName, N)
        Referents_by_File = _read_ref(N)
        start_qrs = floor(Int64, Ref_File.QRS_onset) #начало комплекса QRS (INT)
        end_qrs = floor(Int64, Ref_File.QRS_end)
        start_signal = floor(Int64, Referents_by_File.ibeg) #в Ref_File нет поля начала и конца сигнала(ibeg)
        end_signal = floor(Int64,  Referents_by_File.iend) #в Ref_File нет поля начала и конца сигнала(iend)

        #Сигнал в виде массива
        signals_channel = Sign_Channel(Signal)

        #Референтная разметка QRS
        if BaseName == "CTS"
            Ref_qrs = [QRS_start_CTS[N], QRS_start_CTS[N]+QRS_dur_CTS[N]]
        else 
        
            Ref_qrs = All_Ref_QRS(signals_channel[1], start_qrs, end_qrs, start_signal, end_signal)
        end

        return Names_files, signals_channel, Frequency, Ref_qrs#, Ref_P, start_signal, end_signal
    end

        #Второстепенные функции
        #Функция, которая говорит расположение расположение той или иной базы данных
    #Вход - имя базы данных (пример "CSE")
    #Выход - кортеж имен для данной базы данных(allbinfiles), Путь к базе данных(raw_base_data)
    function Position_Data_Base(Type_Data_base)
        if (Type_Data_base == "CSE")
            raw_base_data = Raw_CSE_MA_Data_Base_Incart # синтетические ЭКГ CSE_MA
            allbinfiles = getfileslist(raw_base_data) 
        elseif (Type_Data_base == "CTS")
            raw_base_data = Raw_CTS_Data_Base_Incart # синтетические ЭКГ CTS
            allbinfiles = getfileslist(raw_base_data) 
        else
            return false, false
        end

        return allbinfiles, raw_base_data 
    end


    #Референтная разметка для данной базы данных
    #Вход - имя базы данных ("CSE") наименование файла ("MA1_001")
    #Выход - Data_base (имя базы данных); ref_file (референтная разметка для данного файла); ref_all_file (референтная разметка для всех файлов); raw_ref (путь к референтной разметке)
    function Referent_Data_Base(Data_base, filename)
        if (Data_base == "CSE" || Data_base == "CTS")
            if(Data_base == "CSE")
                raw_ref = Raw_CSE_Ref_Incart
            elseif(Data_base == "CTS")
                raw_ref = Raw_CTS_Ref_Incart
            else
                return false
            end

            ref_all_file = read_all_ref(raw_ref) 
            fn_ref = filename[1:2] == "MA" ? "MO" * filename[3:end] : filename

            ref_file = ref_all_file[fn_ref]

            return Data_base, ref_file, ref_all_file, raw_ref
        else
            return false, false, false, false
        
        end
    end


    #Функция считывания сигнала
    #Вход - Имя базы данных BaseName (пример "CSE"), номер файла N(пример 12)
    #Выход - имя файла, сигнал, частота, референтная
    function Read_Signal(BaseName, N)
        #проверка на ошибок для Базы данных
        Names_files, Raw_Base_Date = Position_Data_Base(BaseName)

        if (Raw_Base_Date == false)
            return "Ошибка: Неверное наименование (или путь) для Базы Данных"
        end

        File_Name = Names_files[N]
        #проверка на ошибок в реферетной разметке (будет вылетать программа, если неверно)
        Data_Base_Name, Ref_File, Ref_All_File, Raw_Ref = Referent_Data_Base(BaseName, File_Name)

        if (Data_Base_Name == false)
            return "Ошибка: Неверное наименование (или путь) референтной разметки или номер файла"
        end

        #Считываем сигнал
        signals, fs, time, cor = readbin("$(Raw_Base_Date)/$(File_Name)") 

        return Names_files[N], signals, fs, Ref_File
    end

    #Функция записывает сигнал в 12 каналов
    #Вход: Структура сигнала (Signal)
    #Выход: Массив, в которм 12 ячеек
    function Sign_Channel(Signal)
        return [Signal.I, Signal.II, Signal.III, Signal.aVR, Signal.aVL, Signal.aVF, Signal.V1, Signal.V2, Signal.V3, Signal.V4, Signal.V5, Signal.V6]
    end


    #Функция составления реферетной разметки для QRS
    #На вход границы qrs и границы сигнала, на выход все рефенетнаые границы qrs 
    #Верно только для искусственнного сигнала
    function All_Ref_QRS(signals, start_qrs, end_qrs, start_sig, end_sig)
        Distance = end_sig - start_sig
        dur_qrs = end_qrs - start_qrs
        All_ref_qrs = Int64[]

        push!(All_ref_qrs, start_qrs)
        push!(All_ref_qrs, end_qrs)

        index = start_qrs + Distance

        while (index < length(signals))
            push!(All_ref_qrs, index)

            if (index + dur_qrs < length(signals))
                push!(All_ref_qrs, index + dur_qrs)
            end

            index = index + Distance + 1
        end

        return All_ref_qrs
    end

    
    using Distances, DynamicAxisWarping
#Q, R, QR, QRS, RS, RSR
function DTW_kNN(Signal, k, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)

    temps = []
    for i in 1:length(Templates_RS) #new_Templates_RS new_Templates_RSR new_Templates_QR new_Templates_QRS new_Templates_R new_Templates_Q
        Templates = Templates_RS[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RS"))
    end
    for i in 1:length(Templates_RSR) 
        Templates = Templates_RSR[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RSR"))
    end
    for i in 1:length(Templates_QR) 
        Templates = Templates_QR[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QR"))
    end
    for i in 1:length(Templates_QRS) 
        Templates = Templates_QRS[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QRS"))
    end
    for i in 1:length(Templates_R) 
        Templates = Templates_R[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "R"))
    end
    for i in 1:length(Templates_Q) 
        Templates = Templates_Q[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "Q"))
    end
    temps_sort = sort!(temps, by = x -> x[1]);

    return temps_sort[1:k]
end

#Нормировка размаха к 1000 единицам
function scope(Sig)
    minim, maxim = extrema(Sig)
    koeff = (maxim - minim)/1000
    Sig = (Sig ./ koeff)
end

#Нулевой уровенеь сигнала
function Zeros_signal(all_si)
    if all_si[1] != 0
        all_si = (all_si .- (all_si[1]))
    end
return all_si
end

#Обработка сигнала (нормировка и нудево уровень)
function Processing_Signal(Signal)
    return scope(Zeros_signal(Signal))
end

    export Signal_all_channels, Processing_Signal
end