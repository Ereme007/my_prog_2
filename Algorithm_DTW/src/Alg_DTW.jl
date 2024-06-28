#==========================25/06/2024==========================#
#Подключение компонентов
using Plots, JLD2
#include("../Module_Get_Signal.jl")
include("Module_Signal.jl")
#include("function_DTW.jl")
import .Module_Signal as m_signal
@load "src/Templates/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
@load "src/Templates/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
#QRS_start_CTS = [181, 225, 135, 180, 180, 180, 180, 130, 180, 180, 180, 180, 180, 180, 180, 130, 180, 180]
#QRS_dur_CTS = [94, 94,94,100,100,100,100,100,56,56,56,56,56,56,36,36,100,100]
#@save "src/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
@load "src/Templates/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

plotly()

#Результаты dtw для отделього файла(и базы) и отведения БЕЗ обрботки
BaseName, N, Channels = "CSE", 2, 3
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs = m_signal.Signal_all_channels(BaseName, N)
#1)для CTS
#    @load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
#    Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]

#2)для CSE
    Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]
plot(Signal)
    Result , all = m_signal.Result_DTW(6, m_signal.scope(m_signal.Zeros_signal(Signal)), scope_More_Templates_CTS_Q, scope_More_Templates_CTS_R, scope_More_Templates_CTS_QR, scope_More_Templates_CTS_QRS, scope_More_Templates_CTS_RS, scope_More_Templates_CTS_RSR)
    Result #определили к какому классу



#Результаты dtw для отделього файла(и базы) и отведения с обрботкой - сигнал сс нулевого уровня и размах 1000 единиц
BaseName, N, Channels = "CSE", 60, 11
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs = m_signal.Signal_all_channels(BaseName, N)
##1)для CTS
#    @load "test/Module/Summarize/QRS_start_and_dur_for_CTS.jld2" QRS_start_CTS QRS_dur_CTS
#    Signal = const_signal[Channels][QRS_start_CTS[N]:QRS_start_CTS[N]+QRS_dur_CTS[N]]

#2)для CSE
   Signal = const_signal[Channels][Ref_qrs[1]:Ref_qrs[2]]

Result , all = m_signal.Result_DTW(6, m_signal.scope(m_signal.Zeros_signal(Signal)), scope_More_Templates_CTS_Q, scope_More_Templates_CTS_R, scope_More_Templates_CTS_QR, scope_More_Templates_CTS_QRS, scope_More_Templates_CTS_RS, scope_More_Templates_CTS_RSR)
res
all
#Result = DTW_kNN(scope(Zeros_signal(Signal)), 6, scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)
Result[1][2] #определили к какому классу
plot(scope(Zeros_signal(Signal)))

#Отрисовка шаблонов БЕЗ обработки
plot_templates(Templates_CTS_Q, Templates_CTS_R, Templates_CTS_QR, Templates_CTS_QRS, Templates_CTS_RS, Templates_CTS_RSR)

#Отрисовка шаблонов с обработкой
plot_templates(scope_Templates_CTS_Q, scope_Templates_CTS_R, scope_Templates_CTS_QR, scope_Templates_CTS_QRS, scope_Templates_CTS_RS, scope_Templates_CTS_RSR)

plot_templates(scope_More_Templates_CTS_Q, scope_More_Templates_CTS_R, scope_More_Templates_CTS_QR, scope_More_Templates_CTS_QRS, scope_More_Templates_CTS_RS, scope_More_Templates_CTS_RSR)


Signal
plot(Signal)

res, all = m_signal.Result_DTW(6, m_signal.scope(m_signal.Zeros_signal(Signal)), scope_More_Templates_CTS_Q, scope_More_Templates_CTS_R, scope_More_Templates_CTS_QR, scope_More_Templates_CTS_QRS, scope_More_Templates_CTS_RS, scope_More_Templates_CTS_RSR)
res
all