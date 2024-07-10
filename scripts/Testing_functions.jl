using JLD2

###По одному шаблону на каждый класс, без изменений (CTS)
##@load "src/Templates/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
###По одному шаблону на каждый класс с одинаковым размахом, начинающиеся с нулевого уровня
##@load "src/Templates/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
#Несколько шаблонов на каждый класс(неравномерное распределение шаблонов по классу) с одинаковым размахом, начинающиеся с нулевого уровня
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

Templates_Q = scope_More_Templates_CTS_Q
Templates_QR = scope_More_Templates_CTS_QR
Templates_QRS = scope_More_Templates_CTS_QRS
Templates_RS = scope_More_Templates_CTS_RS
Templates_RSR = scope_More_Templates_CTS_RSR
Templates_R = scope_More_Templates_CTS_R

#=
"""
Создание структуры шаблонов
"""
struct Template
    name::String
    signal::Vector{Float64}
end
All_Templates = Template[]

map(Templates_Q) do fn
    push!(All_Templates, Template("Q", fn))
end

map(Templates_QR) do fn
    push!(All_Templates, Template("QR", fn))
end

map(Templates_QRS) do fn
    push!(All_Templates, Template("QRS", fn))
end

map(Templates_RS) do fn
    push!(All_Templates, Template("RS", fn))
end

map(Templates_RSR) do fn
    push!(All_Templates, Template("RSR", fn))
end

map(Templates_R) do fn
    push!(All_Templates, Template("R", fn))
end
All_Templates

#@save "src/Templates/All_Templates_map.jld2" All_Templates
=#
@load "src/Templates/All_Templates_map.jld2" All_Templates
All_Templates




"""Тесты алгоритма DTW"""

include("../src/Readers.jl")
import .Readers as rd

include("../src/DTWfunc.jl")
import .DTWfunc as dtw

include("../src/Plotting.jl")
import .Plotting as pl
using Plots, JLD2
plotly()
@load "src/Templates/All_Templates_map.jld2" All_Templates

#Определяем базу и номер сигнала
BaseName, N = "CSE", 60 #имеем базы "CSE" и "CTS"

#Определяем сигнал
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)

Channel, K = 5, 4 #номер отведения и k-бижайших соседей для оценки

#Сигнал БЕЗ преобразований с отметкой реферетной рзаметки QRS (расширено окно на величину Space)
Space = 30
Signal = signals_channel[Channel][Ref_qrs[1]-Space:Ref_qrs[2]+Space]
plot(Signal)
vline!([Space, Ref_qrs[2]-Ref_qrs[1]+Space])
#Сигнал С преобразованями (без расширения, начало и конец окна являются реферетой разметкой QRS)
Signal = signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]
plot!(Signal)

Pr_Signal = rd.Processing_Signal(Signal)
plot(Pr_Signal)

#Сохраниение сигнала (предварительно необходимо отключить функцию plotly() )
#savefig("src/Question/$(N)_$(Channel).png")   

#(Signal, k, Templates)
ResultDTW, _ = dtw.Result_DTW(K, Pr_Signal, All_Templates)
#=
struct Template
    name::String
    signal::Vector{Float64}
end
=#

pl.Classificate_templates(All_Templates)
pl.create_name_signals(All_Templates)


#анализ результатов (вручную)
Q = [68, 0, 0, 10, 0, 15]
QR = [4, 18, 10, 0, 47, 22]
QRS = [4, 2, 15, 12, 14, 0]
RS = [17, 0, 83, 193, 21, 1]
R = [2, 0, 13, 1, 66, 0]
RSR=[0, 0, 0, 0, 0, 1]

#Сохраниеие оценки классификатора:
#pl.Save_ref_test_csv("Test2_stats", Q, R, QR, QRS, RS, RSR)

include("../src/Templates/QRS_true.jl")
Tabel = zeros(Int, (2, 3) )

[горизонталь, вертикаль]
M1 = 1
M2 = 3
Tabel[M1, M2] = Tabel[M1, M2] + 1
typeof(Tabel[M1, M2])
С = trunc(Int, (Tabel[M1, M2]))
typeof(С)

A = ["1", "4", "2", "3", "2"]

C = "3"
mm = findall(x->x==C, A)
typeof(mm[1])
trunc(Int, mm)

floor(Int, 2.2)