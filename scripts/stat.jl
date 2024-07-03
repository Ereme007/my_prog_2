include("../src/Readers.jl")
import .Readers as rd

include("../src/DTWfunc.jl")
import .DTWfunc as dtw

include("../src/Plotting.jl")
import .Plotting as pl

using Plots
plotly()

#По одному шаблону на каждый класс, без изменений (CTS)
@load "src/Templates/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
#По одному шаблону на каждый класс с одинаковым размахом, начинающиеся с нулевого уровня
@load "src/Templates/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
#Несколько шаблонов на каждый класс(неравномерное распределение шаблонов по классу) с одинаковым размахом, начинающиеся с нулевого уровня
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

#Берём за шаблоны, которых модет быть несколько в каждом классе, имеющий одинаковый размах, начинающиеся с нулевого уровня.
Templates_Q = scope_More_Templates_CTS_Q
Templates_QR = scope_More_Templates_CTS_QR
Templates_QRS = scope_More_Templates_CTS_QRS
Templates_RS = scope_More_Templates_CTS_RS
Templates_RSR = scope_More_Templates_CTS_RSR
Templates_R = scope_More_Templates_CTS_R

#Отрисовка шаблонов
pl.plot_templates(Templates_Q, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR, Templates_R)

##Отрисовка сигнала с сопостовлением для него класса
#Определяем базу и номер сигнала
BaseName, N = "CSE", 2 #имеем базы "CSE" и "CTS"

#Определяем сигнал
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)

Channel, K = 4, 4 #номер отведения и k-бижайших соседей для оценки

#Сигнал БЕЗ преобразований
Signal = signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]
plot(Signal)
#Сигнал С преобразованями
Pr_Signal = rd.Processing_Signal(Signal)
plot!(Pr_Signal)
#Отрисовка сиганла с сопостовлением для него класса
#Результат выполнения алгоритма DTW
Pr_Signal
ResultDTW, _ = dtw.Result_DTW(Pr_Signal, K, Templates_Q, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR, Templates_R)
ResultDTW

pl.plots_result(K, Signal, Templates_Q, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR, Templates_R)
#Изначальный сегмент сигнала БЕЗ обработки
plot(Signal, title = "Изначальный сигнал", label = false)

#Сохраняем статистику (определён CSE база для 60ти сигналов по 12 отведений), первый параметр - имя файла. Сохраняется в папке Stats
#pl.Save_csv("Test1", K, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)
plot(signals_channel[Channel])

#Нормировка по средним квадратов