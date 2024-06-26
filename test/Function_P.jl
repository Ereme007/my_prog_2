
#Много вспомогательных функций
include("../src/my_filt.jl")

#Функция нахождения локального максимума с заданным радиусом 
#Вход: сигнал(Signal), радиус(rad)
#Выход: массив максимумов (Massiv_max)
function new_localmax(Signal, rad)
    Massiv_max = Int64[]
    size_signal = length(Signal)
    i = 1

    while (i <= size_signal)
        max = Signal[i]
        
        for j in (i-rad):(i+rad)
            if (j >= 1 && j < size_signal && Signal[j] > max)
                max = Signal[j]
            end
        end

        if (Signal[i] == max)
            push!(Massiv_max, i)
            i = i + rad
        else
            i = i + 1
        end

    end

    return Massiv_max
end


#Функция нахождения локального минимума с заданным радиусом 
#Вход: сигнал(Signal), радиус(rad)
#Выход: массив минимумов (Massiv_min)
function new_localmin(Signal, rad)
    Massiv_min = Int64[]
    size_signal = length(Signal)
    i = 1

    while (i <= size_signal)
        min = Signal[i]
        for j in (i-rad):(i+rad)
            if (j >= 1 && j < size_signal && Signal[j] < min)
                min = Signal[j]
                #    @info j
            end
        end

        if (Signal[i] == min)
            push!(Massiv_min, i)
            i = i + rad - 1
        else
            i = i + 1
        end
    end

    return Massiv_min
end


#Использован
#Функция записывает сигнал в 12 каналов
#Вход: Структура сигнала (Signal)
#Выход: Массив, в которм 12 ячеек
function Sign_Channel(Signal)
    return [Signal.I, Signal.II, Signal.III, Signal.aVR, Signal.aVL, Signal.aVF, Signal.V1, Signal.V2, Signal.V3, Signal.V4, Signal.V5, Signal.V6]
end

#Использован
#Функция "Зануление" qrs по середине
#Вход: Облатсь поиска P(All_ref_qrs), сигнал массив(signals), начало/конец qrs (start_qrs/end_qrs)
#Выход: Новый сигнал массив
function Zero_qrs(All_ref_qrs, signals, start_qrs, end_qrs)
    i = 2
    size = length(All_ref_qrs)

    while (i <= size)
        
        for channel in 1:12
            signals[channel][All_ref_qrs[i-1]:(floor(Int64, All_ref_qrs[i-1] + (end_qrs - start_qrs) / 2))] .= signals[channel][All_ref_qrs[i-1]-1]
            signals[channel][(floor(Int64, All_ref_qrs[i-1] + (end_qrs - start_qrs) / 2)):All_ref_qrs[i]] .= signals[channel][All_ref_qrs[i]+1]
        end

        i = i + 2
    end
    
    return signals
end


#(НЕ)Использован
#Функция "Зануление" qrs по левому краю
#Вход: Облатсь поиска P(All_ref_qrs), сигнал массив(signals)
#Выход: Новый сигнал массив
function Simple_Zero_qrs(All_ref_qrs, signals)
    i = 2
    size = length(All_ref_qrs)

    while (i <= size)
        for channel in 1:12
            signals[channel][All_ref_qrs[i-1]:All_ref_qrs[i]] .= signals[channel][All_ref_qrs[i-1]-1]
        end

        i = i + 2
    end

    return signals
end


#Функция возрастания, определяемая по 2м точками
#Вход: координаты X и Y двух точек (Xa, Xb, Ya, Yb)
#Выход: (Yb-Ya)/(Xb-Xa)
function greed(Xa, Xb, Ya, Yb)
    return (Yb-Ya)/(Xb-Xa)
end


#Функция "Зануление" qrs в виде линии
#Вход: Облатсь поиска P(All_ref_qrs), сигнал массив(signals)
#Выход: Новый сигнал массив (signals)
function Line_qrs(All_ref_qrs, signals)
    i = 2
    size = length(All_ref_qrs)
    #@info "size = $size"

    while (i <= size)
        for channel in 1:12
            rise = greed(All_ref_qrs[i-1], All_ref_qrs[i], signals[channel][All_ref_qrs[i-1]-1], signals[channel][All_ref_qrs[i]-1])
            coord_y = signals[channel][All_ref_qrs[i-1]-1]
            coord_x_1 = All_ref_qrs[i-1]
            #@info "signals[channel][coord_1] = $(signals[channel][coord_1])"
            #@info "coord_y = $(coord_y)"
            
            for coord_x in All_ref_qrs[i-1]:All_ref_qrs[i]
                signals[channel][coord_x] = coord_y + rise
                coord_y = coord_y + rise
            end

        end

        i = i + 2
    end
    
    return signals
end


#Функция определяющая облатсь поиска P
#Вход: частота (fs), реферетная разметка qrs (All_ref_qrs), начало/конец сигнала (all_strat/all_end)
#Выход: левая/правая граница облатси поиска волны Р (left_p/right_p)
function Segment_left_right_P(fs, All_ref_qrs, all_strat, all_end)
    koeff = 1000 / fs
    left_p, right_p = Int64[], Int64[]
    #первая итерация!!
    first_P_right = All_ref_qrs[1]
    first_P_left = floor(Int64, All_ref_qrs[1] - (all_end - all_strat) / 2)

    if (first_P_left < 0)
        first_P_left = 1
    end

    push!(left_p, first_P_left)

    if (first_P_right - first_P_left < (fs))
        push!(right_p, first_P_right)
    else
        push!(right_p, first_P_left + (fs))
    end

    #следующая итерации i+2
    i = 3

    while (i < length(All_ref_qrs))
        #левая
        center_qq = All_ref_qrs[i] - (all_end - all_strat) / 2
        q_with_150 = All_ref_qrs[i-1] + 150 / koeff

        if (center_qq < q_with_150)
            P_left = floor(Int64, q_with_150)
        else
            P_left = floor(Int64, center_qq)
        end

        push!(left_p, P_left)

        #правая
        P_right = All_ref_qrs[i]

        if (P_right - P_left > (fs))
            P_right = floor(Int64, P_left + (fs))
        end

        push!(right_p, P_right)
        i = i + 2
    end

    return left_p, right_p
end


#Функция применяет к сигналу my_butter
#Вход: Сигнал ~без_qrs (signal), частота (fs)
#Выход: измененный сигнал (change_signal)
function Graph_my_butter(signal, fs)
    change_signal = []
    
    for current_channel in 1:12
        graph_butter = my_butter(signal[current_channel], 2, (2, 20), fs, Bandpass)
        push!(change_signal, graph_butter)
    end
    
    return change_signal
end


#Функция применяет к сигналу DiffFilt
#Вход: Сигнал (signal), дистанция производной (dist)
#Выход: измененный сигнал (change_signal)
function Graph_diff(signal, dist)
    change_signal = []
    
    for current_channel in 1:12
        graph_diff = DiffFilt(signal[current_channel], dist)
        push!(change_signal, graph_diff)
    end

    return change_signal
end


#Функция определения всеx точкек мин мах на всех отведениях и участках
#Вход: Область поиска волны P (Place_found_P_Left_and_Right), Сигнал (Signal), Радиус поиска ~.env (RADIUS_LOCAL)
#Выход: массив точек All_points = [Max_local, Min_local]
function All_points_with_channels_max_min(Place_found_P_Left_and_Right, Signal, RADIUS_LOCAL)
    All_points = []
    
    for channel in 1:12
        Min_local = []
        Max_local = []
        
        for i in 1:length(Place_found_P_Left_and_Right[1])
            Start = Place_found_P_Left_and_Right[1][i]
            End = Place_found_P_Left_and_Right[2][i]
            Max_l = new_localmax(Signal[channel][Start:End], RADIUS_LOCAL)
            Min_l = new_localmin(Signal[channel][Start:End], RADIUS_LOCAL)

            push!(Min_local, Min_l .+ (Start - 1))
            push!(Max_local, Max_l .+ (Start - 1))
        end

        push!(All_points, [Max_local, Min_local])
    end

    return All_points
end


#Отсортировка
#Вход: массив ми и мак точек (Massiv_Points)
#Выход: отстортированные (point_sort_channel) 
function Sort_points_with_channel(Massiv_Points)
    point_sort_channel = []
    
    for channel in 1:12
        Mass_chan = Massiv_Points[channel]
        points_sort = []
        
        for k in 1:length(Mass_chan[1])
            new = []
            
            for i in 1:length(Mass_chan[1][k])
                val = Mass_chan[1][k][i]
                push!(new, val) #заполнили min
            end

            for i in 1:length(Mass_chan[2][k])
                val = Mass_chan[2][k][i]
                push!(new, val) #заполнили max
            end
            
            push!(points_sort, sort(new)) # все min и max и отрортировали
        end
        
        push!(point_sort_channel, points_sort)
    end

    return point_sort_channel
end


#Нахождение амплитуды и границ по одному каналу (последняя цифра - номер канала)
#Massiv_Points_channel = Sort_points_with_channel() - сортируем точки по возрастанию на всех каналах по своим промежуткам (т.е.  Sort_points_with_channel[1] - означает для 1го канала рассматриваются все области поиска, на которых в порядке возрастания расставлены локальные точки)

#Пояснение многомерного массива "Massiv_Points_channel"
#Massiv_Points_channel[channel] # на отведении channel столько отрезков (length)
#Massiv_Points_channel[channel][2] #облать имеющий номер 2
#Massiv_Points_channel[channel][2][1] #точка по X
#На вход: массив точек(Massiv_Points_channel), сигнал (singnal), коэффициент(koeff), канал(channel), радиус(RADIUS)
#На выход: AMP_START_END - структура, которая содержит амплитуду. индекс левой и правой границы фронта
function amp_one_channel(Massiv_Points_channel, singnal, koeff, channel, RADIUS)
    #@info "Start amp_one_channel"
    #@info "Rad = $RADIUS"
    f_index = first_index = 0
    l_index = last_index = 0
    #только 1ая облась
    AMP_START_END = []
    FINAL_amp = 0
    #   OBLAST_with_channel = []
    
    for current_segment in 1:length(Massiv_Points_channel[channel]) # (цикл от 1 области зубца P, который возможен в сигнале до последней области - Amp_start_end)
        # @info "current_segment = $current_segment" 
        Max_amp = 0

        for i in 1:length(Massiv_Points_channel[channel][current_segment])
            # @info "счетчик = $i" 
            amp = 0

            for k in (i+1):(i+3)
                #  @info "значение K = $k" 
                
                if (((k + 1) <= length(Massiv_Points_channel[channel][current_segment])) && abs(Massiv_Points_channel[channel][current_segment][i] - Massiv_Points_channel[channel][current_segment][k]) < RADIUS / koeff) #тут вылезет!
                    #  @info "зашли внутрь" 
                    before = Massiv_Points_channel[channel][current_segment][k-1]
                    after = Massiv_Points_channel[channel][current_segment][k]
                    #  @info "wtf k! = $k"                 
                    amp = amp + abs(singnal[channel][before] - singnal[channel][after])
                    f_index = i
                    l_index = k
                    #@info "inside amp = $amp" 
                end
                
                if (Max_amp < amp)
                    #  @info "Max_amp = $Max_amp and amp = $amp "
                    Max_amp = amp
                    first_index = i
                    #  @info "first index = $i"
                    last_index = l_index
                    # @info "last index = $l_index"
                end

            end
            # push!(AMP_START_END, [Max_amp, first_index, last_index])
            FINAL_amp = Max_amp
        end
        
        push!(AMP_START_END, [FINAL_amp, first_index, last_index])
        #  запоминаем, что на участке под номером OBL, амплитуду Max_amp, начало и конец first_index last_index
    end
    #push!(OBLAST_with_channel, AMP_START_END)

    return AMP_START_END
end


#Сведение к 12 каналам
#На вход: массив точек(Massiv_Points_channel), сигнал(signal), коэффициент(koeff), радиус (RADIUS)
#На выход: массив из 12и отведений (Final_massiv)
function amp_all_cannel(Massiv_Points_channel, signal, koeff, RADIUS)
    Final_massiv = []
    
    for channel in 1:12
        push!(Final_massiv, amp_one_channel(Massiv_Points_channel, signal, koeff, channel, RADIUS))
    end
    
    return Final_massiv
end



#====================================================================#

#Нахождение амплитуды и границ по одному каналу (последняя цифра - номер канала)
#Massiv_Points_channel = Sort_points_with_channel() - сортируем точки по возрастанию на всех каналах по своим промежуткам (т.е.  Sort_points_with_channel[1] - означает для 1го канала рассматриваются все области поиска, на которых в порядке возрастания расставлены локальные точки)

#Пояснение многомерного массива "Massiv_Points_channel"
#Massiv_Points_channel[channel] # на отведении channel столько отрезков (length)
#Massiv_Points_channel[channel][2] #облать имеющий номер 2
#Massiv_Points_channel[channel][2][1] #точка по X
#На вход: массив точек(Massiv_Points_channel), сигнал (singnal), коэффициент(koeff), канал(channel), радиус(RADIUS)
#На выход: AMP_START_END - структура, которая содержит амплитуду. индекс левой и правой границы фронта
function amp_one_channel_(Massiv_Points_channel, singnal, koeff, channel, RADIUS)
    #@info "Start amp_one_channel"
    #@info "Rad = $RADIUS"
    f_index = first_index = 0
    l_index = last_index = 0
    #только 1ая облась
    AMP_START_END = []
    FINAL_amp = 0
    #   OBLAST_with_channel = []
    All_Amp = []
    All_Amp_by_channel = []
    for current_segment in 1:length(Massiv_Points_channel[channel]) # (цикл от 1 области зубца P, который возможен в сигнале до последней области - Amp_start_end)
        # @info "current_segment = $current_segment" 
        Max_amp = 0

        for i in 1:length(Massiv_Points_channel[channel][current_segment])
            # @info "счетчик = $i" 
            amp = 0

            for k in (i+1):(i+3)
                #  @info "значение K = $k" 
                
                if (((k + 1) <= length(Massiv_Points_channel[channel][current_segment])) && abs(Massiv_Points_channel[channel][current_segment][i] - Massiv_Points_channel[channel][current_segment][k]) < RADIUS / koeff) #тут вылезет!
                    #  @info "зашли внутрь" 
                    before = Massiv_Points_channel[channel][current_segment][k-1]
                    after = Massiv_Points_channel[channel][current_segment][k]
                    #  @info "wtf k! = $k"                 
                    amp = amp + abs(singnal[channel][before] - singnal[channel][after])
                    f_index = i
                    l_index = k
                    #@info "inside amp = $amp" 
                end
                push!(All_Amp, [amp, i, l_index])
                if (Max_amp < amp)
                    #  @info "Max_amp = $Max_amp and amp = $amp "
                    Max_amp = amp
                    first_index = i
                    #  @info "first index = $i"
                    last_index = l_index
                    # @info "last index = $l_index"
                end

            end
            # push!(AMP_START_END, [Max_amp, first_index, last_index])
            FINAL_amp = Max_amp
        end
        
        push!(AMP_START_END, [FINAL_amp, first_index, last_index])
        push!(All_Amp_by_channel, All_Amp)
        #  запоминаем, что на участке под номером OBL, амплитуду Max_amp, начало и конец first_index last_index
    end
    #push!(OBLAST_with_channel, AMP_START_END)

    return AMP_START_END
end


#Сведение к 12 каналам
#На вход: массив точек(Massiv_Points_channel), сигнал(signal), коэффициент(koeff), радиус (RADIUS)
#На выход: массив из 12и отведений (Final_massiv)
function amp_all_cannel_(Massiv_Points_channel, signal, koeff, RADIUS)
    Final_massiv = []
    
    for channel in 1:12
        push!(Final_massiv, amp_one_channel_(Massiv_Points_channel, signal, koeff, channel, RADIUS))
    end
    
    return Final_massiv
end
