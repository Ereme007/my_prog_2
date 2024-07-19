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

Channel, K = 1, 4 #номер отведения и k-бижайших соседей для оценки

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

#Дополняем Начальную Выборку
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

Templates_Q = scope_More_Templates_CTS_Q
Templates_QR = scope_More_Templates_CTS_QR
Templates_QRS = scope_More_Templates_CTS_QRS
Templates_RS = scope_More_Templates_CTS_RS
Templates_RSR = scope_More_Templates_CTS_RSR
Templates_R = scope_More_Templates_CTS_R



#=HERE!=#
BaseName = "CSE" #имеем базы "CSE" и "CTS"
K = 4
N, Channel  = 10, 4 #номер отведения и k-бижайших соседей для оценки
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)

Space = 30
Signal = signals_channel[Channel][Ref_qrs[1]-Space:Ref_qrs[2]+Space]
plot(Signal)

Pr_Signal = rd.Processing_Signal(Signal)
plot(Pr_Signal)
vline!([Space, Ref_qrs[2]-Ref_qrs[1]+Space])

const_Signal = signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]
const_Pr_Signal = rd.Processing_Signal(const_Signal)
ResultDTW, _ = dtw.Result_DTW(K, Pr_Signal, Add_All_Templates)
ResultDTW, _ = dtw.Result_DTW(K, const_Pr_Signal, All_Templates)
plot(const_Pr_Signal)
plot(const_Signal)


#Add_Templates_Q1 = []
#Add_Templates_QR1 = []
#push!(Add_Templates_QR, const_Pr_Signal)
#Add_Templates_QRS1 =[] 
#Add_Templates_RS1 =[]
#Add_Templates_RSR1 = []
#Add_Templates_R1 = []
#Add_Templates_QRS1 = [Add_Templates[1].signal, Add_Templates[2].signal]
push!(Add_Templates_QRS1, const_Pr_Signal)
Add_Templates = []
map(Add_Templates_QRS1) do fn
    push!(Add_Templates, Template("QRS", fn))
end
plot(const_Pr_Signal)

#@save "src/Templates/Add_QRS_1and2and3.jld2" Add_Templates
@load "src/Templates/Add_QRS_1and2.jld2" Add_Templates
Add_Templates_QRS = Add_Templates
#Add_Templates_QR = Add_Templates_QR[1:4]
Add_Templates_QR

struct Template
    name::String
    signal::Vector{Float64}
end
function Union_Templates(First_Templates, Second_Templates)
    union_templates = []
    map(First_Templates) do fir_t
        push!(union_templates, fir_t)
    end
    map(Second_Templates) do sec_t
        push!(union_templates, sec_t)
    end
    return union_templates
end
#@save "src/Templates/New_test.jld2" Add_Templates
@load "src/Templates/New_test.jld2" Add_Templates
#@save "src/Templates/Add_QR_1and2and3and4.jld2" Add_Templates
@load "src/Templates/Add_QR_1and2and3and4.jld2" Add_Templates
Add_Templates_QR = Add_Templates



All_Templates


Add_Templates_QRS
Add_Templates_QR
Add_All_Templates = Union_Templates(All_Templates, Add_Templates_QR)
Add_All_Templates = Union_Templates(Add_All_Templates, Add_Templates_QRS)

#pl.Save_csv("Add_QR_3", 4, Add_All_Templates)

include("../src/Stats.jl")
import.Stats as st
include("../src/Templates/QRS_true.jl")

#New_Tabel, res = st.evaluation_classifiers("Stats_evaluation", All_Templates, MO, 60)


New_Tabel, res = st.evaluation_classifiers("Stats_evaluation_add_QRS2_QR_templates", Add_All_Templates, MO, 60)
N, Channel
Add_All_Templates


#=++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=#
#Заново!

include("../src/Readers.jl")
import .Readers as rd
include("../src/DTWfunc.jl")
import .DTWfunc as dtw
include("../src/Plotting.jl")
import .Plotting as pl
include("../src/Stats.jl")
import.Stats as st
include("../src/Templates/QRS_true.jl"); QRS_true = MO
include("../src/Templates/QRS_true_NEW.jl"); QRS_true_2 = MO_2
include("../src/Templates/QRS_true_NEW2.jl"); QRS_true_22 = MO_22
struct Template
    name::String
    signal::Vector{Float64}
end
using Distances, DynamicAxisWarping, JLD2
@load "src/Templates/All_Templates_map.jld2" All_Templates
#using Plots; plotly()
function Union_Templates(First_Templates, Second_Templates)
    union_templates = []
    map(First_Templates) do fir_t
        push!(union_templates, fir_t)
    end
    map(Second_Templates) do sec_t
        push!(union_templates, sec_t)
    end
    return union_templates
end

BaseName = "CSE"
K = 4
All_Templates

N, Channel  = 1, 4 #номер отведения и k-бижайших соседей для оценки
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
signal = rd.Processing_Signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]) 
#plot(signal)
ResultDTW, _ = dtw.Result_DTW(K, signal, All_Templates)

New_Templates = []
Add_Templates_QR = [Template("QR", signal)]; push!(New_Templates, Add_Templates_QR11)
ResultDTW, _ = dtw.Result_DTW(K, signal, Add_Templates_QR)

#@save "src/Test/QR.jld2" Add_Templates_QR
@load "src/Test/QR.jld2" Add_Templates_QR
Add_Templates_QR


Add_Templates_QR[1].name

Un_Templates = Union_Templates(All_Templates, Add_Templates_QR)
ResultDTW, _ = dtw.Result_DTW(K, signal, All_Templates)

New_Tabel, res = st.evaluation_classifiers("Stats_QR1_templates", Un_Templates, QRS_true_2, 60, "False")

#include("../src/Stats.jl")
#import.Stats as st
"""
Сохраним все сигналы, которые мы инетрпетируем как Q QR QRS RS R RSR
"""

QRS_true[22][ 1]

function Save_Templ(QRS_true, All_Templates)
BaseName = "CSE"
K = 4
New_t = []

for N in 1:60

    names_temps = ["Q", "QR", "QRS", "RS", "R", "RSR", "-"]
    Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    for Channel in 1:12
        signal = rd.Processing_Signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]) 
        ResultDTW, _ = dtw.Result_DTW(K, signal, All_Templates)
        if QRS_true[N][Channel] != ResultDTW && QRS_true[N][Channel] != "-"
            push!(New_t, Template(QRS_true[N][Channel], signal))
        end
    end
end
return New_t
end

Neww = Save_Templ(QRS_true_2, All_Templates)

Un_Templates = Union_Templates(All_Templates, Neww)

New_Tabel, res = st.evaluation_classifiers("ALL", Un_Templates, QRS_true_2, 60, "False")


Neww2 = Save_Templ(QRS_true_2, Un_Templates)

Un_Templates2 = Union_Templates(Un_Templates, Neww2)
length(Un_Templates2)
Un_Templates2[1:0]
New_Tabel2, res = st.evaluation_classifiers("ALL", Un_Templates2, QRS_true_2, 60, "False")

#plot(Un_Templates2[1].signal)
#Придумать программу, которая будет убирать темлейты и не изменяется тем самым результат
function CH(Temps)
    RES = 678 
    size = length(Temps)
    Bases = []
    COUNT_same, COUNT_nosame = 0, 0
 for i in 0:(size-1)
 #    i = 10
        End_Temp = Temps[i+2:size]
        Union = Union_Templates(Bases, End_Temp)   
        _, res = st.evaluation_classifiers("ALL", Union, QRS_true_2, 60, "False")
    if res == RES
        COUNT_same = COUNT_same + 1
        @info "$(i+1)) Совпали = ($COUNT_same)"
    else
        COUNT_nosame = COUNT_nosame + 1
        @info "$(i+1)) Не совпали = ($COUNT_nosame)"
        push!(Bases, Template(Temps[i+1].name, Temps[i+1].signal)) 
    end
    i = i+1
end

return Bases
end


BB = CH(Un_Templates2)
Result_Templates = BB
Result_Templates
##
###@save "src/Test/Result_Templates.jld2" Result_Templates
##@load "src/Test/Result_Templates.jld2" Result_Templates
#@save "src/Test/Result_Templates_4.jld2" Result_Templates
@load "src/Test/Result_Templates_4.jld2" Result_Templates
Result_Templates
_, res = st.evaluation_classifiers("Result_Templates", Result_Templates, QRS_true_2, 60, "False")

length(Result_Templates)
mass_Q = []
mass_QR = []
mass_QRS = []
mass_RS = []
mass_R = []
mass_RSR = []
for i in 1:length(Result_Templates)
    if Result_Templates[i].name == "Q"
        push!(mass_Q, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "QR"
        push!(mass_QR, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "QRS"
        push!(mass_QRS, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "RS"
        push!(mass_RS, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "R"
        push!(mass_R, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "RSR"
        push!(mass_RSR, Result_Templates[i].signal)
    end
end
plot(mass_Q[1])

BaseName = "CSE"
using Plots
plotly()

si = mass_Q[1]; plot(si)
ResultDTW, _ = dtw.Result_DTW(2, si, All_Templates)
Space, Numb, Chan = 40, 0, 0
for N in 1:60
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    for Ch in 1:12 
    test_signal = rd.Processing_Signal(signals_channel[Ch][Ref_qrs[1]:Ref_qrs[2]])
        if test_signal == si
            @info "N = $N and Ch = $Ch"
            Numb = N
            Chan = Ch
        end
    end
end
Numb,Chan
#Numb,Chan = 55, 8 #47  и 1

Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, Numb)
test_signal = rd.Processing_Signal(signals_channel[Chan][Ref_qrs[1]:Ref_qrs[2]]); plot(test_signal)
test_signal2 = signals_channel[Chan][Ref_qrs[1]-Space:Ref_qrs[2]+Space]; plot(test_signal2)
ResultDTW, _ = dtw.Result_DTW(K, test_signal, Result_Templates)


Un_Templates2
#их 692
New_Base = [Un_Templates[1:3]; Un_Templates[6:7];Un_Templates[9:11];Un_Templates[14:15]; Un_Templates[18]; Un_Templates[20]; Un_Templates[22:311]]
@time New_Tabel2, res = st.evaluation_classifiers("ALL", New_Base, QRS_true, 60)

#ВАЖНО Для отрисовки! scatter!((2, 10),text="Text annotation with arrow",title = "nothing", color = "purple") 


N = 1, BaseName = "CSE"
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)



function signals12(all_si)
    level = 1100
    for i in 1:12
    if all_si[i][1] != level
        all_si[i] = (all_si[i] .- (all_si[i][1] - level))
    end
    level = level - 200
end
    
    return all_si
end

function signals12_level(all_si, level)
    if all_si[1] != level
        all_si = (all_si .- (all_si[1] - level))
    end
   
    return all_si
end


plot(All_Templates[9].signal)
plot!(All_Templates[10].signal)
plot!(All_Templates[11].signal)


TT = Result_Templates
for N in 1:60
    names_temps = ["Q", "QR", "QRS", "RS", "R", "RSR", "-"]
    Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    for Channel in 1:12
        signal = rd.Processing_Signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]) 
        ResultDTW, _ = dtw.Result_DTW(1, signal, Result_Templates)
        if QRS_true_2[N][Channel] != ResultDTW && QRS_true_2[N][Channel] != "-"
            @info "N = $N, Channel = $Channel"
            @info "QRS_true_2[N][Channel] = $(QRS_true_2[N][Channel]) and ResultDTW = $(ResultDTW)"
        end
    end
end


############################################
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, 2)
signal = rd.Processing_Signal(signals_channel[12][Ref_qrs[1]:Ref_qrs[2]]) 
ResultDTW, _ = dtw.Result_DTW(1, signal, Result_Templates3[4:192])

plot(signal)


function plots_signal_12_channels(BaseName, N, Result_Templates)
    Space = 100
    Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    sig = rd.Processing_Signal(signals_channel[1][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    start_lvl = 5000
    plot(signals12_level(sig, start_lvl - Space*1))
 
    scatter!((1, start_lvl - Space*1), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[2][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*2))
    scatter!((1, start_lvl - Space*2), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[3][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*3))
    scatter!((1, start_lvl - Space*3), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[4][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*4))
    scatter!((1, start_lvl - Space*4), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[5][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*5))
    scatter!((1, start_lvl - Space*5), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[6][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*6))
    scatter!((1, start_lvl - Space*6), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[7][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*7))
    scatter!((1, start_lvl - Space*7), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[8][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*8))
    scatter!((1, start_lvl - Space*8), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[9][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*9))
    scatter!((1, start_lvl - Space*9), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[10][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*10))
    scatter!((1, start_lvl - Space*10), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[11][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*11))
    scatter!((1, start_lvl - Space*11), text=ResultDTW, color = "purple") 

    sig = rd.Processing_Signal(signals_channel[12][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, _ = dtw.Result_DTW(1, sig, Result_Templates)
    plot!(signals12_level(sig, start_lvl - Space*12))
    scatter!((1, start_lvl - Space*12), text=ResultDTW, color = "purple") 
    plot!(title = Names_files)
end
plots_signal_12_channels("CSE", 1, Result_Templates)


include("../src/Stats.jl")
import.Stats as st

@load "src/Test/Result_Templates_2.jld2" 
Result_Templates2 = Result_Templates
@load "src/Test/Result_Templates_3.jld2" Result_Templates
Result_Templates3 = Result_Templates
New_Tabel2, res2 = st.evaluation_classifiers("ALL", Result_Templates2, QRS_true_2, 60)
New_Tabel3, res3 = st.evaluation_classifiers("classifiers_Result_Templates3", Result_Templates3, QRS_true_2, 60)

New_Tabel3_1, res3_1 = st.evaluation_classifiers("classifiers_Result_Templates3_without3", Result_Templates3[4:192], QRS_true_22, 60)



#192 шаблона
n = 9
plot(Result_Templates2[n].signal, title = Result_Templates2[n].name)

#si = mass_QRS[1]; plot(si)
si = Result_Templates2[n].signal; plot(si)
ResultDTW, _ = dtw.Result_DTW(2, si, All_Templates)
Space, Numb, Chan = 40, 0, 0
for N in 1:60
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    for Ch in 1:12 
    test_signal = rd.Processing_Signal(signals_channel[Ch][Ref_qrs[1]:Ref_qrs[2]])
        if test_signal == si
            @info "N = $N and Ch = $Ch"
            Numb = N
            Chan = Ch
        end
    end
end
Numb,Chan
Numb,Chan = 2, 12 #47  и 1

Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, Numb)
test_signal = rd.Processing_Signal(signals_channel[Chan][Ref_qrs[1]:Ref_qrs[2]]); plot(test_signal)
test_signal2 = signals_channel[Chan][Ref_qrs[1]-Space:Ref_qrs[2]+Space]; plot(test_signal2); vline!([Space, Ref_qrs[2]-Space])
ResultDTW, _ = dtw.Result_DTW(K, test_signal, Result_Templates)




function plots_dtw_test_sig2(BaseName, Number, Channel, Templates)
    Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, Number)
    signal = rd.Processing_Signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]])
    ResultDTW, Temp_Signal = dtw.Result_DTW_with_signal(1, signal, Templates)
@info "res_dtw = $ResultDTW"
    p = (plot(Temp_Signal, color=:red, label="template");plot!(signal, color=:black, label="signal", title = "$ResultDTW: $Names_files, channel = $Channel "))
    return p, Temp_Signal
end

#===Сплошное тестирвоание===#
include("../src/Readers.jl")
import .Readers as rd
include("../src/DTWfunc.jl")
import .DTWfunc as dtw
include("../src/Plotting.jl")
import .Plotting as pl
include("../src/Stats.jl")
import.Stats as st
@load "src/Templates/All_Templates_map.jld2" All_Templates #шаблоны из CTS
include("../src/Templates/QRS_true_NEW2.jl"); QRS_true = MO_22 #Корректная разметка
function SAVE_temps(Temps, REF_QRS, RES)
    #RES = 678 
    size = length(Temps)
    Bases = []
    COUNT_same, COUNT_nosame = 0, 0
 for i in 0:(size-1)
 #    i = 10
        End_Temp = Temps[i+2:size]
        Union = Union_Templates(Bases, End_Temp)   
        _, res = st.evaluation_classifiers("ALL", Union, REF_QRS, 60, "False")
    if res == RES
        COUNT_same = COUNT_same + 1
        @info "$(i+1)) Совпали = ($COUNT_same)"
    else
        COUNT_nosame = COUNT_nosame + 1
        @info "$(i+1)) Не совпали = ($COUNT_nosame)"
        push!(Bases, Template(Temps[i+1].name, Temps[i+1].signal)) 
    end
    i = i+1
end

return Bases
end

Neww = Save_Templ(QRS_true, All_Templates)
Un_Templates = Union_Templates(All_Templates, Neww)
New_Tabel, res = st.evaluation_classifiers("ALL", Un_Templates, QRS_true, 60, "False")

Neww2 = Save_Templ(QRS_true, Un_Templates)
Un_Templates2 = Union_Templates(Un_Templates, Neww2)
length(Un_Templates2)
New_Tabel2, res = st.evaluation_classifiers("ALL", Un_Templates2, QRS_true, 60, "False")
res
BB = SAVE_temps(Un_Templates2, QRS_true, res)
Result_Templates = BB
#@save "src/Test/Result_Templates_5.jld2" Result_Templates
@load "src/Test/Result_Templates_5.jld2" Result_Templates ; Result_Templates#их 189

length(Result_Templates)
mass_Q = []
mass_QR = []
mass_QRS = []
mass_RS = []
mass_R = []
mass_RSR = []
for i in 1:length(Result_Templates)
    if Result_Templates[i].name == "Q"
        push!(mass_Q, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "QR"
        push!(mass_QR, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "QRS"
        push!(mass_QRS, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "RS"
        push!(mass_RS, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "R"
        push!(mass_R, Result_Templates[i].signal)
    elseif Result_Templates[i].name == "RSR"
        push!(mass_RSR, Result_Templates[i].signal)
    end
end

#Это шаблоны из базы CSE в количестве 
#Всего сигналов 679
#Просиходит сохранение ("True" - то сохранится, если другое - не сохранится)
New_Tabel, res = st.evaluation_classifiers("Save_11_Templates", All_Templates, QRS_true, 60, "True")

#Где возникают ошибки? определим функцию 
function Ch_Res(Templates, ref_comlex_qrs)
    scripts_plot = []

    for N in 1:60
    Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    for Channel in 1:12
        signal = rd.Processing_Signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]]) 
        ResultDTW, _ = dtw.Result_DTW_with_signal(1, signal, Templates)
        if ref_comlex_qrs[N][Channel] != ResultDTW && ref_comlex_qrs[N][Channel] != "-"
            @info "N = $N, Channel = $Channel"
            @info "ref_comlex_qrs[N][Channel] = $(ref_comlex_qrs[N][Channel]) and ResultDTW = $(ResultDTW)"
            push!(scripts_plot, plot(signal, title="Number $N; Channel $Channel", label="DTW = $ResultDTW; Ref = $(ref_comlex_qrs[N][Channel])"))
        end
    end
end
return scripts_plot
end

i = Ch_Res(Result_Templates, QRS_true)


Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, 47)
signal = rd.Processing_Signal(signals_channel[1][Ref_qrs[1]:Ref_qrs[2]]) 
ResultDTW, _ = dtw.Result_DTW(2, signal, Result_Templates)

QRS_true[47][1]
i[1]
i[2]


plots_signal_12_channels("CSE", 1, Result_Templates)


s1, sis1 = pl.plots_dtw_test_sig("CSE", 31, 4, Result_Templates)
s1
QRS_true[31][4]
#s2, sis2 = pl.plots_dtw_test_sig("CSE", 47, 1, All_Templates)
QRS_true[47][1]
s1
mass_Q
plot(mass_Q[11])

si = mass_QR[9]; plot(si)
Space, Numb, Chan = 40, 0, 0
for N in 1:60
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
    for Ch in 1:12 
    test_signal = rd.Processing_Signal(signals_channel[Ch][Ref_qrs[1]:Ref_qrs[2]])
        if test_signal == si
            @info "N = $N and Ch = $Ch"
            Numb = N
            Chan = Ch
        end
    end
end

Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, 15)
Space = 100

plot(signals_channel[3][Ref_qrs[1]-Space:Ref_qrs[2]+Space]); vline!([Space, Ref_qrs[2]-Ref_qrs[1]+Space])


mass_Q
mass_QR
mass_QRS
mass_RS
mass_R
mass_RSR


plot(mass_QR[6:10])