include("../Module_Get_Signal.jl")
include("function_DTW.jl")

using Plots, JLD2
import .Module_Get_Signal as m_get_signal
#QRS_start_CTS = [181, 225, 135, 180, 180, 180, 180, 130, 180, 180, 180, 180, 180, 180, 180, 130, 180, 180]
#QRS_dur_CTS = [94, 94,94,100,100,100,100,100,56,56,56,56,56,56,36,36,100,100]
#@save "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS

plotly()
BaseName, N = "CTS", 4
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
Names_files
#QRS_start = 180
#QRS_dur = QRS_dur_CTS[N]#+300
Channels = 4
#Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]
#Signal = const_signal[Channels][QRS_start:QRS_start+QRS_dur]
plot(Signal, legend = false)

@load "test/Module/Summarize/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
plot_templates(Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
#@save "test/Module/Summarize/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
#Templates_CTS_QR = []
#push!(Templates_CTS_QR, Signal)
plot(Templates_CTS_QR, legend = false)
Templates_CTS_QR[1]
#plot(Signal)
minim, maxim = extrema(Templates_CTS_Q[1])
(maxim - minim)/1000

#Q, R, QR, QRS, RS, RSR
DTW_kNN(Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)




#@load "test/Module/Summarize/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
#scope_Templates_CTS_Q = []
#push!(scope_Templates_CTS_Q, scope(Templates_CTS_Q[1]))
#
#
#scope_Templates_CTS_QR = []
#push!(scope_Templates_CTS_QR, scope(Templates_CTS_QR[1]))
#
#
#scope_Templates_CTS_QRS = []
#push!(scope_Templates_CTS_QRS, scope(Templates_CTS_QRS[1]))
#
#
#scope_Templates_CTS_RS = []
#push!(scope_Templates_CTS_RS, scope(Templates_CTS_RS[1]))
#
#
#scope_Templates_CTS_RSR = []
#push!(scope_Templates_CTS_RSR, scope(Templates_CTS_RSR[1]))
#
#
#scope_Templates_CTS_R = []
#push!(scope_Templates_CTS_R, scope(Templates_CTS_R[1]))
#
#
#@save "test/Module/Summarize/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R
@load "test/Module/Summarize/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R


BaseName, N = "CSE", 2
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
Channels = 1
Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]


Test1 = DTW_kNN(Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
Test1[1]
plot(Signal)
zero_Signal = Zeros_signal(Signal)
plot!(zero_Signal)

Test2 = DTW_kNN(zero_Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
Test2[1]

Test3 = DTW_kNN(scope(zero_Signal), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
plot!(scope(zero_Signal))
Test3[1]
Save_csv("Result_without_norm", Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)

Save_csv_norm("Result_with_norm_MORE", scope_More_Templates_CTS_Q, scope_More_Templates_CTS_R, scope_More_Templates_CTS_QR, scope_More_Templates_CTS_QRS, scope_More_Templates_CTS_RS, scope_More_Templates_CTS_RSR)


NUMBER = 1
    BaseName = "CSE"
    Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
    QRS_start = Ref_qrs[1]
    QRS_end = Ref_qrs[2]
    push!(Mass_Names_files, Names_files)
    
    Signal = const_signal[3][QRS_start:QRS_end]
    plot(Signal)
    Test1 = DTW_kNN(Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)


    Signal
    #scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR
    Templates = scope_Templates_CTS_RS
    scope_Templates_CTS_RS
    Templates_CTS_RS
    #plot(Signal)
    dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1]



    #Для базы данных CTS
    
BaseName, N = "CTS", 14
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
Names_files
Channels = 1
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Test3[1][2]
Channels = 2
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 3
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 4
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 5
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 6
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 7
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
#plot(scope(Zeros_signal(Signal)), color = :red)
#plot!(More_Templates_CTS_RS, color = :green)
#plot!(scope_Templates_CTS_RSR, color = :black)

Channels = 8
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 9
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 10
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 11
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Channels = 12
#@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
Test3 = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)






Test1 = DTW_kNN(Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
Test1[1]
plot(Signal)
zero_Signal = Zeros_signal(Signal)
plot!(zero_Signal)

Test2 = DTW_kNN(zero_Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
Test2[1]

Test3 = DTW_kNN(scope(zero_Signal), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
plot!(scope(zero_Signal))
Test3[1]
ss



#Чуть-чуть расширенный 
#
@load "test/Module/Summarize/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
plotly()
BaseName, N = "CTS", 9
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
Names_files
Channels = 1
Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]
plot(Signal, legend = false)
plot!(Templates_CTS_R)


#More_Templates_CTS_RS = Templates_CTS_RS
#RS, rS
#R 
#push!(More_Templates_CTS_RS, Signal)
More_Templates_CTS_RS = Templates_CTS_RS


plots_sugnal_with_name("CTS", 1, QRS_start_CTS, QRS_dur_CTS)


#Увеличиваем кол-во шаблонов, взятых из CTS
#More_Templates_CTS_RS = Templates_CTS_RS

#Результаты dtw для отделього файла(и базы) и отведения с обрботкой - сигнал сс нулевого уровня и размах 1000 единиц
BaseName, N, Channels = "CTS", 4, 5
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
#1)для CTS
    @load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
    Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]

##2)для CSE
#   Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]
#
Result = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Result[1][2] #определили к какому классу
plot(scope(Zeros_signal(Signal)), legend = false)


#push!(More_Templates_CTS_RS, Signal)

#More_Templates_CTS_Q, More_Templates_CTS_R


More_Templates_CTS_Q
More_Templates_CTS_R
More_Templates_CTS_QR
More_Templates_CTS_QRS
More_Templates_CTS_RS
More_Templates_CTS_RSR
#@save "test/Module/Summarize/More_Templates_CTS.jld2" More_Templates_CTS_Q More_Templates_CTS_QR More_Templates_CTS_QRS More_Templates_CTS_RS More_Templates_CTS_RSR More_Templates_CTS_R

#scorpe_More_Templates_CTS_RSR = []
#push!(scorpe_More_Templates_CTS_RSR, scope(Zeros_signal(More_Templates_CTS_RSR[1])))
#@save "test/Module/Summarize/scorpe_More_Templates_CTS.jld2" scorpe_More_Templates_CTS_Q scorpe_More_Templates_CTS_QR scorpe_More_Templates_CTS_QRS scorpe_More_Templates_CTS_RS scorpe_More_Templates_CTS_RSR scorpe_More_Templates_CTS_R
@load "test/Module/Summarize/More_Templates_CTS.jld2" More_Templates_CTS_Q More_Templates_CTS_QR More_Templates_CTS_QRS More_Templates_CTS_RS More_Templates_CTS_RSR More_Templates_CTS_R
#scope_More_Templates_CTS_Q = scorpe_More_Templates_CTS_Q 
#scope_More_Templates_CTS_QR = scorpe_More_Templates_CTS_QR
#scope_More_Templates_CTS_QRS = scorpe_More_Templates_CTS_QRS 
#scope_More_Templates_CTS_RS = scorpe_More_Templates_CTS_RS
#scope_More_Templates_CTS_RSR = scorpe_More_Templates_CTS_RSR 
#scope_More_Templates_CTS_R = scorpe_More_Templates_CTS_R 
#@save "test/Module/Summarize/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R
@load "test/Module/Summarize/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R



#==========================25/06/2024==========================#
#Подключение компонентов
using Plots, JLD2
include("../Module_Get_Signal.jl")
include("function_DTW.jl")
import .Module_Get_Signal as m_get_signal
@load "test/Module/Summarize/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
@load "test/Module/Summarize/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
@load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
plotly()

#Вывод результатов с отображением графиков (результат с обработкой)
plots_sugnal_with_name("CTS", 1, QRS_start_CTS, QRS_dur_CTS)

#Результаты dtw для отделього файла(и базы) и отведения БЕЗ обрботки
BaseName, N, Channels = "CSE", 2, 3
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
#1)для CTS
#    @load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
#    Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]

#2)для CSE
    Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]

Result = DTW_kNN(Signal, 6, Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)
Result[1][2] #определили к какому классу



#Результаты dtw для отделього файла(и базы) и отведения с обрботкой - сигнал сс нулевого уровня и размах 1000 единиц
BaseName, N, Channels = "CSE", 60, 11
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
##1)для CTS
#    @load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
#    Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]

#2)для CSE
   Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]

Result = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_More_Templates_CTS_Q, scope_More_Templates_CTS_R, scope_More_Templates_CTS_QR, scope_More_Templates_CTS_QRS, scope_More_Templates_CTS_RS, scope_More_Templates_CTS_RSR)

#Result = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Result[1][2] #определили к какому классу
plot(scope(Zeros_signal(Signal)))

#Отрисовка шаблонов БЕЗ обработки
plot_templates(Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)

#Отрисовка шаблонов с обработкой
plot_templates(scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)

