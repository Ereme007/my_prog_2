struct Template
    name::String
    signal::Vector{Float64}
end
#По одному шаблону на каждый класс, без изменений (CTS)
@load "src/Templates/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
#По одному шаблону на каждый класс с одинаковым размахом, начинающиеся с нулевого уровня
@load "src/Templates/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
#Несколько шаблонов на каждый класс(неравномерное распределение шаблонов по классу) с одинаковым размахом, начинающиеся с нулевого уровня
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

Templates_Q = scope_More_Templates_CTS_Q
Templates_QR = scope_More_Templates_CTS_QR
Templates_QRS = scope_More_Templates_CTS_QRS
Templates_RS = scope_More_Templates_CTS_RS
Templates_RSR = scope_More_Templates_CTS_RSR
Templates_R = scope_More_Templates_CTS_R

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

using JLD2
@save "src/Templates/All_Templates_map.jld2" All_Templates

All_Templates
temps = []
map(All_Templates) do fn
    #push!(temps, (fn.))
    @info "$(fn.name)"
end



"""Теперь DTW"""

include("../src/Readers.jl")
import .Readers as rd

include("../src/DTWfunc.jl")
import .DTWfunc as dtw

include("../src/Plotting.jl")
import .Plotting as pl
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
plot(Pr_Signal)
#(Signal, k, Templates)
ResultDTW2, _ = dtw.second_Result_DTW(Pr_Signal, K, All_Templates)
ResultDTW, _ = dtw.Result_DTW(Pr_Signal, K, Templates_Q, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR, Templates_R)

plotly()
ResultDTW2
ResultDTW
All_Templates[1].signal
i = 2
plot(All_Templates[i].signal, title = All_Templates[i].name)