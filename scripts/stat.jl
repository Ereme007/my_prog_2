include("../src/Readers.jl")
import .Readers as rd

include("../src/DTWfunc.jl")
import .DTWfunc as dtw

include("../src/Plotting.jl")
import .Plotting as pl

using Plots, JLD2
plotly()

###По одному шаблону на каждый класс, без изменений (CTS)
##@load "src/Templates/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
###По одному шаблону на каждый класс с одинаковым размахом, начинающиеся с нулевого уровня
##@load "src/Templates/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
#Несколько шаблонов на каждый класс(неравномерное распределение шаблонов по классу) с одинаковым размахом, начинающиеся с нулевого уровня
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

@load "src/Templates/All_Templates_map.jld2" All_Templates


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
@load "src/Templates/All_Templates_map.jld2" All_Templates
ResultDTW2, _ = dtw.Result_DTW(K, Pr_Signal, All_Templates)
ResultDTW2


#Отрисовка классифицированного сигнала
pl.plots_result(K, Pr_Signal, All_Templates)
plot!(scope_More_Templates_CTS_RSR[1])
plot!(scope_More_Templates_CTS_QRS[1])

#Изначальный сегмент сигнала БЕЗ обработки
plot(Signal, title = "Изначальный сигнал", label = false)

#Сохраняем статистику (определён CSE база для 60ти сигналов по 12 отведений), первый параметр - имя файла. Сохраняется в папке Stats rjl jghtltktybz if,jkjyjd gj htfkmysv 'ru
pl.Save_csv("Test3", K, All_Templates)

#Нормировка по средним квадратов ?! 