using ContinuousWavelets, Wavelets, Distances, DynamicAxisWarping, Plots
using CSV, Tables, DataFrames

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

#Q, R, QR, QRS, RS, RSR
function plot_templates(Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
    plot_Q = plot(Templates_CTS_Q, title = "Q")
    plot_QR = plot(Templates_CTS_QR, title = "QR")
    plot_QRS = plot(Templates_CTS_QRS, title = "QRS")
    plot_RS = plot(Templates_CTS_RS, title = "RS")
    plot_RSR = plot(Templates_CTS_RSR, title = "RSR")
    plot_R = plot(Templates_CTS_R, title = "R")

    plot(plot_Q,plot_R,plot_QR,plot_QRS,plot_RS,plot_RSR, legend = false)
end





function Save_csv(name, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)

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
    K = 6
    for i in 1:60
    NUMBER = i
    BaseName = "CSE"
    Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
    QRS_start = Ref_qrs[1]
    QRS_end = Ref_qrs[2]
    push!(Mass_Names_files, Names_files)

    Signal = const_signal[1][QRS_start:QRS_end]
    #L1 = Return_only_complex(const_signal, 1)
    L1 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(First_ch, L1)
if i == 1
  #  @info "First_ch = $L1"
end
    Signal = const_signal[2][QRS_start:QRS_end]
    #L2 = Return_only_complex(const_signal, 2)
    L2 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Second_ch, L2)

    Signal = const_signal[3][QRS_start:QRS_end]
    #L3 = Return_only_complex(const_signal, 3)
    L3 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2] 
    push!(Third_ch, L3)

    Signal = const_signal[4][QRS_start:QRS_end]
    #L4 = Return_only_complex(const_signal, 4)
    L4 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Four_ch, L4)

    Signal = const_signal[5][QRS_start:QRS_end]
    #L5 = Return_only_complex(const_signal, 5)
    L5 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Five_ch, L5)

    Signal = const_signal[6][QRS_start:QRS_end]
    #L6 = Return_only_complex(const_signal, 6)
    L6 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Six_ch, L6)

    Signal = const_signal[7][QRS_start:QRS_end]
    #L7 = Return_only_complex(const_signal, 7)
    L7 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Seven_ch, L7)

    Signal = const_signal[8][QRS_start:QRS_end]
    #L8 = Return_only_complex(const_signal, 8)
    L8 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Eight_ch, L8)

    Signal = const_signal[9][QRS_start:QRS_end]
    #L9 = Return_only_complex(const_signal, 9)
    L9 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Nine_ch, L9)

    Signal = const_signal[10][QRS_start:QRS_end]
    #L10 = Return_only_complex(const_signal, 10)
    L10 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Ten_ch, L10)

    Signal = const_signal[11][QRS_start:QRS_end]
    #L11 = Return_only_complex(const_signal, 11)
    L11 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Eleven_ch, L11)

    Signal = const_signal[12][QRS_start:QRS_end]
    #L12 = Return_only_complex(const_signal, 12)
    L12 = DTW_kNN(Signal, K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
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
    CSV.write("test/Module/Summarize/Template_CTS/$(name).csv", text, delim = ';')
    end
end



function Save_csv_norm(name, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)

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
    K = 6
    for i in 1:60
    NUMBER = i
    BaseName = "CSE"
    Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
    QRS_start = Ref_qrs[1]
    QRS_end = Ref_qrs[2]
    push!(Mass_Names_files, Names_files)

    Signal = const_signal[1][QRS_start:QRS_end]
    #L1 = Return_only_complex(const_signal, 1)
    L1 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(First_ch, L1)
if i == 1
   # @info "First_ch = $L1"
end
    Signal = const_signal[2][QRS_start:QRS_end]
    #L2 = Return_only_complex(const_signal, 2)
    L2 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Second_ch, L2)

    Signal = const_signal[3][QRS_start:QRS_end]
    #L3 = Return_only_complex(const_signal, 3)
    L3 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2] 
    push!(Third_ch, L3)

    Signal = const_signal[4][QRS_start:QRS_end]
    #L4 = Return_only_complex(const_signal, 4)
    L4 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Four_ch, L4)

    Signal = const_signal[5][QRS_start:QRS_end]
    #L5 = Return_only_complex(const_signal, 5)
    L5 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Five_ch, L5)

    Signal = const_signal[6][QRS_start:QRS_end]
    #L6 = Return_only_complex(const_signal, 6)
    L6 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Six_ch, L6)

    Signal = const_signal[7][QRS_start:QRS_end]
    #L7 = Return_only_complex(const_signal, 7)
    L7 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Seven_ch, L7)

    Signal = const_signal[8][QRS_start:QRS_end]
    #L8 = Return_only_complex(const_signal, 8)
    L8 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Eight_ch, L8)

    Signal = const_signal[9][QRS_start:QRS_end]
    #L9 = Return_only_complex(const_signal, 9)
    L9 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Nine_ch, L9)

    Signal = const_signal[10][QRS_start:QRS_end]
    #L10 = Return_only_complex(const_signal, 10)
    L10 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Ten_ch, L10)

    Signal = const_signal[11][QRS_start:QRS_end]
    #L11 = Return_only_complex(const_signal, 11)
    L11 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
    push!(Eleven_ch, L11)

    Signal = const_signal[12][QRS_start:QRS_end]
    #L12 = Return_only_complex(const_signal, 12)
    L12 = DTW_kNN(scope(Zeros_signal(Signal)), K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)[1][2]
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
    CSV.write("test/Module/Summarize/Template_CTS/$(name).csv", text, delim = ';')
    end
end


#Нулевой уровенеь сигнала
function Zeros_signal(all_si)
        if all_si[1] != 0
            all_si = (all_si .- (all_si[1]))
        end
    return all_si
end

#Нормировка размаха к 1000 единицам
function scope(Sig)
    minim, maxim = extrema(Sig)
    koeff = (maxim - minim)/1000
    Sig = (Sig ./ koeff)
end


function plots_sugnal_with_name(BaseName, N, QRS_start_CTS, QRS_dur_CTS)
    Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
    Signal = const_signal[1][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch1 = plot(Signal , title = Test3)
    
    Signal = const_signal[2][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch2 = plot(Signal , title = Test3)
    
    Signal = const_signal[3][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch3 = plot(Signal , title = Test3)
    
    Signal = const_signal[4][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch4 = plot(Signal , title = Test3)
    
    Signal = const_signal[5][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch5 = plot(Signal , title = Test3)
    
    Signal = const_signal[6][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch6 = plot(Signal , title = Test3)
    
    Signal = const_signal[7][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch7 = plot(Signal , title = Test3)
    
    Signal = const_signal[8][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch8 = plot(Signal , title = Test3)
    
    Signal = const_signal[9][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch9 = plot(Signal , title = Test3)
    
    Signal = const_signal[10][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch10 = plot(Signal , title = Test3)
    
    Signal = const_signal[11][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch11 = plot(Signal , title = Test3)
    
    Signal = const_signal[12][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
    Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)[1][2]
    ch12 = plot(Signal , title = Test3)

    plot(ch1, ch2, ch3, ch4, ch5, ch6, ch7, ch8, ch9, ch10, ch11, ch12, legend = false)
end