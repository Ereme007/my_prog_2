module Plotting
    include("DTWfunc.jl")
    import .DTWfunc as dtw

    include("../src/Readers.jl")
    import .Readers as rd
    
    using Plots
    using CSV, Tables, DataFrames
    
    """
    Считываем шаблоны
    """
    function Classificate_templates(all_temps)
        name_templates = []#[all_temps[1].name]
    
        flag = false
        map(all_temps) do fn
            for i in 1:length(name_templates)
                flag = false
                
                if(name_templates[i] == fn.name)
                            flag = true
                    break
                end
            end
            if flag == false
                push!(name_templates, fn.name)
            end
        end
        
        return name_templates
    end
    
    """
    К одному кдассу записываем несколько шаблонов (на выходе кортеж)
    """
    function create_name_signals(all_temps)
        names_temps = Classificate_templates(all_temps)
        Summarize = []
        map(names_temps) do names
            massiv_sig = []
            map(all_temps) do fn
                current_name = names
                if current_name == fn.name
                    push!(massiv_sig, fn.signal)
                end
            end
            curr_name_signal = names
            
            push!(Summarize, (curr_name_signal, massiv_sig))
        end
        
        return Summarize
    end
    """
    Отрисовка шаблонов
    """
    #Q, R, QR, QRS, RS, RSR
    function plot_templates(Q, QR, QRS, RS, RSR, R)
        plot_Q = plot(Q, title = "Q")
        plot_QR = plot(QR, title = "QR")
        plot_QRS = plot(QRS, title = "QRS")
        plot_RS = plot(RS, title = "RS")
        plot_RSR = plot(RSR, title = "RSR")
        plot_R = plot(R, title = "R")

        plot(plot_Q,plot_R,plot_QR,plot_QRS,plot_RS,plot_RSR, legend = false)
    end

    """
    Отрисовка сиганла с сопостовлением для него класса
    """

    function plots_result(K, Sig, Templates)
        Res, _ = dtw.Result_DTW(K, Sig, Templates)
        plot(Sig, legend = false, title = Res)
    end

    """
    Функция сохраниния статистики в csv формате
    name - имя файла (в папке Stats)
    База данных (в данном случае) "CSE"
    """
    function Save_csv(name, K, All_Templates)#, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR, Templates)
        Mass_Names_files = []
        First_ch = []
        Second_ch = []
        Third_ch = []
        Four_ch = []
        Five_ch = []
        Six_ch = []
        Seven_ch = []
        Eight_ch = []
        Nine_ch = []
        Ten_ch = []
        Eleven_ch = []
        Twelve_ch = []
       BaseName = "CSE"
        for i in 1:60
        NUMBER = i
        Names_files, const_signal,  Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, NUMBER)
        QRS_start = Ref_qrs[1]
        QRS_end = Ref_qrs[2]
        push!(Mass_Names_files, Names_files)
    
        Signal = const_signal[1][QRS_start:QRS_end]
        L1, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates)
        push!(First_ch, L1)

        Signal = const_signal[2][QRS_start:QRS_end]
        L2, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates)
        push!(Second_ch, L2)
    
        Signal = const_signal[3][QRS_start:QRS_end]
        L3, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates)  
        push!(Third_ch, L3)
    
        Signal = const_signal[4][QRS_start:QRS_end]
        L4, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Four_ch, L4)
    
        Signal = const_signal[5][QRS_start:QRS_end]
        L5, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Five_ch, L5)
    
        Signal = const_signal[6][QRS_start:QRS_end]
        L6, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Six_ch, L6)
    
        Signal = const_signal[7][QRS_start:QRS_end]
        L7, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Seven_ch, L7)
    
        Signal = const_signal[8][QRS_start:QRS_end]
        L8, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Eight_ch, L8)
    
        Signal = const_signal[9][QRS_start:QRS_end]
        L9, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Nine_ch, L9)
    
        Signal = const_signal[10][QRS_start:QRS_end]
        L10, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Ten_ch, L10)
    
        Signal = const_signal[11][QRS_start:QRS_end]
        L11, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Eleven_ch, L11)
    
        Signal = const_signal[12][QRS_start:QRS_end]
        L12, _ = dtw.Result_DTW(K, rd.Processing_Signal(Signal), All_Templates) 
        push!(Twelve_ch, L12)
    
        text = DataFrame(
         name_File = Mass_Names_files,
         _1 = First_ch,
         _2 = Second_ch,
         _3 = Third_ch,
         _4 = Four_ch,
         _5 = Five_ch,
         _6 = Six_ch,
         _7 = Seven_ch,
         _8 = Eight_ch,
         _9 = Nine_ch ,
         _10 = Ten_ch,
         _11 = Eleven_ch,
         _12 = Twelve_ch)
        CSV.write("scripts/Stats/$(name).csv", text, delim = ';')
        end
    end


    """
    Функция сохраниния статистики Ref\test в csv формате
    name - имя файла (в папке Stats)
    База данных (в данном случае) "CSE"
    """
    function Save_ref_test_csv(name, Q, R, QR, QRS, RS, RSR)
      #  Test_Q = []
      Name_test = []
      First_ch = []
        Second_ch = []
        Third_ch = []
        Four_ch = []
        Five_ch = []
        Six_ch = []
        mass = ["Q", "QR", "QRS", "RS", "R", "RSR"] 
        for i in 1:6
        NUMBER = i
        push!(Name_test, mass[i])
    
        push!(First_ch, Q[i])
        push!(Second_ch, QR[i])
        push!(Third_ch, QRS[i])
        push!(Four_ch, RS[i])
        push!(Five_ch, R[i])
        push!(Six_ch, RSR[i])
    
        text = DataFrame(
         name_File = Name_test,
         Q = First_ch,
         QR = Second_ch,
         QRS = Third_ch,
         RS = Four_ch,
         R = Five_ch,
         RSR = Six_ch)
        CSV.write("scripts/Stats/$(name).csv", text, delim = ';')
        end
    end

    function plots_dtw_test_sig(BaseName, Number, Channel, Templates)
        Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, Number)
        signal = rd.Processing_Signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]])
        ResultDTW, Temp_Signal = dtw.Result_DTW_with_signal(1, signal, Templates)
    #@info "res_dtw = $ResultDTW"
        p = (plot(Temp_Signal, color=:red, label="template");plot!(signal, color=:black, label="signal", title = "$ResultDTW: $Names_files, channel = $Channel "))
        return p, Temp_Signal
    end
    

    export plot_templates, plots_result, Save_csv, Classificate_templates, create_name_signals, Save_ref_test_csv, plots_dtw_test_sig
end