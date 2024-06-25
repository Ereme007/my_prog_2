include("Module_Get_Signal.jl")
using ContinuousWavelets, Wavelets, Distances, DynamicAxisWarping
using Plots, JLD2
import .Module_Get_Signal as m_get_signal
xt = dwt(ss, wavelet(WT.db2))

@load "Templates_dtw.jld2" Templates_RS_dtw Templates_QR_dtw Templates_QRS_dtw Templates_R_dtw Templates_Q_dtw
@load "Templates_wavelet.jld2" Templates_RS_wavelet Templates_QR_wavelet Templates_QRS_wavelet Templates_R_wavelet Templates_Q_wavelet
@load "Templates_dtw_20_40.jld2" Templates_RS_dtw_20_40 Templates_QR_dtw_20_40 Templates_QRS_dtw_20_40 Templates_R_dtw_20_40 Templates_Q_dtw_20_40
@load "Templates_wavelet_20_40.jld2" Templates_RS_wavelet_20_40 Templates_QR_wavelet_20_40 Templates_QRS_wavelet_20_40 Templates_R_wavelet_20_40 Templates_Q_wavelet_20_40
@load "Templates_dtw_40_60.jld2" Templates_RS_dtw_40_60 Templates_QR_dtw_40_60 Templates_QRS_dtw_40_60 Templates_R_dtw_40_60 Templates_Q_dtw_40_60
@load "Templates_wavelet_40_60.jld2" Templates_RS_wavelet_40_60 Templates_QR_wavelet_40_60 Templates_QRS_wavelet_40_60 Templates_R_wavelet_40_60 Templates_Q_wavelet_40_60
@load "Templates_30_dtw.jld2" Templates_RS_30_dtw Templates_QR_30_dtw Templates_QRS_30_dtw Templates_R_30_dtw Templates_Q_30_dtw
@load "Templates_30_wavelet.jld2" Templates_RS_30_wavelet Templates_QR_30_wavelet Templates_QRS_30_wavelet Templates_R_30_wavelet Templates_Q_30_wavelet


#@load "Templates_summarize.jld2" Templates_RS Templates_RSR Templates_QR Templates_QRS Templates_R Templates_Q
#using JLD2
#@load "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates


#@save "Templates_30_dtw.jld2" Templates_RS_30_dtw Templates_QR_30_dtw Templates_QRS_30_dtw Templates_R_30_dtw Templates_Q_30_dtw
#@save "Templates_30_wavelet.jld2" Templates_RS_30_wavelet Templates_QR_30_wavelet Templates_QRS_30_wavelet Templates_R_30_wavelet Templates_Q_30_wavelet


#Templates_QR_30_dtw, Templates_QR_30_walwet = save_templates(16, 4, Templates_QR_30_dtw, Templates_QR_30_walwet)
#Templates_QR_30_dtw# = Templates_RS_30_dtw[1:20]
#Templates_QR_30_walwet# = Templates_RS_30_walwet[1:20]
#Templates_RS_30_dtw# = [] #all
#Templates_QR_30_dtw# = [] #ALL
#Templates_QRS_30_dtw# = [] #ALL
#Templates_R_30_dtw# = [] #ALL
#Templates_Q_30_dtw# = [] #ALL
#
#Templates_RS_30_walwet# = [] #all
#Templates_QR_30_walwet# = [] #ALL
#Templates_QRS_30_walwet# = [] #ALL
#Templates_R_30_walwet# = [] #ALL
#Templates_Q_30_walwet# = [] #ALL
#Templates_Q_30_wavelet = Templates_Q_30_walwet 

#Templates_Q_dtw_40_60, Templates_Q_wavelet_40_60 = save_templates(54, 6, Templates_Q_dtw_40_60, Templates_Q_wavelet_40_60)
Templates_Q_dtw_40_60
Templates_Q_wavelet_40_60 


function save_templates(NUMBER, Channel, Templates1, Templates2)

BaseName, N = "CSE", NUMBER
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
QRS_start = Ref_qrs[1]
QRS_end = Ref_qrs[2]
Names_files
#Channel = 11
Signal = const_signal[Channel][QRS_start:QRS_end]
push!(Templates1, Signal)

if (length(Signal) %2 == 1)
    push!(Signal, Signal[length(Signal)])
end
Signal2 = dwt(Signal, wavelet(WT.db2))
push!(Templates2, Signal2)
return Templates1, Templates2
end
ss

#plot(Signal)
#plot!(Signal2)
#Templates_RS_dtw_40_60# = [] # ALL
#Templates_QR_dtw_40_60#  = [] # ALL
#Templates_QRS_dtw_40_60#  = [] # ALL
#Templates_R_dtw_40_60#  = [] # ALL
#Templates_Q_dtw_40_60#  = [] # ALL
#
#Templates_RS_wavelet_40_60#  = [] # ALL
#Templates_QR_wavelet_40_60 # = [] # ALL
#Templates_QRS_wavelet_40_60# = [] # ALL
#Templates_R_wavelet_40_60# = [] # ALL
#Templates_Q_wavelet_40_60#  = [] # ALL
#@save "Templates_dtw_40_60.jld2" Templates_RS_dtw_40_60 Templates_QR_dtw_40_60 Templates_QRS_dtw_40_60 Templates_R_dtw_40_60 Templates_Q_dtw_40_60
#@save "Templates_wavelet_40_60.jld2" Templates_RS_wavelet_40_60 Templates_QR_wavelet_40_60 Templates_QRS_wavelet_40_60 Templates_R_wavelet_40_60 Templates_Q_wavelet_40_60


#Templates_RS_dtw = [] #всё
#Templates_RSR_wavelet = [] #
#Templates_QR_dtw = [] #ВСЁ
#Templates_QRS_dtw = [] #ВСЁ
#Templates_R_dtw = [] #ВСЁ
#Templates_Q_dtw = [] #ВСЁ
#push!(Templates_Q_dtw, Signal)
#@save "Templates_dtw.jld2" Templates_RS_dtw Templates_QR_dtw Templates_QRS_dtw Templates_R_dtw Templates_Q_dtw


w_sort = DTW_kNN(Signal, 5)
Def_complex = defenition_complex(w_sort)[1]

w_sort2 = DTW_plus_Wavelet_kNN(Signal, 5)
Def_complex, mmin = defenition_complex(w_sort2)[1]





Signal = const_signal[Channel][QRS_start:QRS_end]
if (length(Signal) %2 == 1)
    push!(Signal, Signal[length(Signal)])
end
#Signal2 = dwt(Signal, wavelet(WT.db2))


#push!(Templates_Q_wavelet, Signal2)

#Templates_RS_wavelet = [] #всё
#Templates_RSR_wavelet = [] #
#Templates_QR_wavelet = [] #ВСЁ
#Templates_QRS_wavelet = [] #ВСЁ
#Templates_R_wavelet = [] #ВСЁ
#Templates_Q_wavelet = [] #ВСЁ
#

#@save "Templates_wavelet.jld2" Templates_RS_wavelet Templates_QR_wavelet Templates_QRS_wavelet Templates_R_wavelet Templates_Q_wavelet
@load "Templates_wavelet.jld2" Templates_RS_wavelet Templates_QR_wavelet Templates_QRS_wavelet Templates_R_wavelet Templates_Q_wavelet



plot(Signal, legend = false)
plotly()

k = [:blue, :red, :green, :black, :blue, :red, :green, :black, :blue, :red, :green, :black]
yMin = -1700
yMax = 1700
#Тут отрисовка для рабоыт с МАМОЙ!
N = 58
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
QRS_start, QRS_end  = Ref_qrs[1], Ref_qrs[2]+10
p = []
for i in 1:12
    push!(p, plot(const_signal[i][QRS_start:QRS_end], color = k[i]))
end
#1вар
plot(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], legend = false, ylim=(yMin, yMax), title=(N))
plotly()

#2вар
#plot(p[1], p[2], p[3], p[4], p[5], p[6], legend = false)
#plot(p[7], p[8], p[9], p[10], p[11], p[12], legend = false)

qwe 
#Templates_RS = [] всё
#Templates_RSR = [] всё
#Templates_QR = [] ВСЁ
#Templates_QRS = [] всё
#Templates_R = [] ВСЁ
#Templates_Q = [] ВСЁ

#push!(Templates_RSR, Signal)

#Templates_RS
#Templates_RSR
#Templates_QR
#Templates_QRS
#Templates_R
#Templates_Q
#plot([Templates_RSR])


#plot!(Signal, color = :black)
using JLD2
#@save "Templates_summarize.jld2" Templates_RS Templates_RSR Templates_QR Templates_QRS Templates_R Templates_Q
@load "Templates_summarize.jld2" Templates_RS Templates_RSR Templates_QR Templates_QRS Templates_R Templates_Q
#new_Templates_RS = near_Zero(Templates_RS)
#new_Templates_RSR = near_Zero(Templates_RSR)
#new_Templates_QR = near_Zero(Templates_QR)
#new_Templates_QRS = near_Zero(Templates_QRS)
#new_Templates_R = near_Zero(Templates_R)
#new_Templates_Q = near_Zero(Templates_Q)



function near_Zero(all_si)
    New_mass = []
    for i in 1:length(all_si)
        if all_si[i][1] != 0
            push!(New_mass, (all_si[i] .- (all_si[i][1])))
        end
    end
    return New_mass
end




function defenition_complex(sort_by_koeff)
    Q, R, QRS, RS, RSR, QR = 0, 0, 0, 0, 0, 0
    for i in 1:length(sort_by_koeff)
        if (sort_by_koeff[i][2] == "Q")
            Q = Q + 1
        end
        if (sort_by_koeff[i][2] == "R")
            R = R + 1
        end
        if (sort_by_koeff[i][2] == "QRS")
            QRS = QRS + 1
        end
        if (sort_by_koeff[i][2] == "RS")
            RS = RS + 1
        end
        if (sort_by_koeff[i][2] == "RSR")
            RSR = RSR + 1
        end
        if (sort_by_koeff[i][2] == "QR")
            QR = QR + 1
        end
    end
    ss = sort(((Q, "Q"), (R, "R"), (QR, "QR"), (QRS, "QRS"), (RSR, "RSR"), (RS, "RS")), by = x -> x[1], rev=true)
    mmin = "No"
    if(ss[1][2] == ss[2][2])
        @info "ss[1][2] = $(ss[1][2])"
        @info "ss[1][2] = $(ss[2][2])"
        if ss[1][1] < ss[2][1]
            mmin = ss[2][1]
        
        else
            mmin = ss[1][1]
        end
    end
    return sort(((Q, "Q"), (R, "R"), (QR, "QR"), (QRS, "QRS"), (RSR, "RSR"), (RS, "RS")), by = x -> x[1], rev=true), mmin
end


#Here

function DTW_kNN(Signal, k)

    temps = []
    for i in 1:length(Templates_RS_dtw) #new_Templates_RS new_Templates_RSR new_Templates_QR new_Templates_QRS new_Templates_R new_Templates_Q
        Templates = Templates_RS_dtw[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RS"))
     #   Templates = Templates_RSR_dtw[i]
     #   push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RSR"))
        Templates = Templates_QR_dtw[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QR"))
        Templates = Templates_QRS_dtw[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QRS"))
        Templates = Templates_R_dtw[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "R"))
        Templates = Templates_Q_dtw[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "Q"))
    end
    temps_sort = sort!(temps, by = x -> x[1]);

    return temps_sort[1:k]
end



function DTW_plus_Wavelet_kNN(Signal, k)
    if (length(Signal) %2 == 1)
        push!(Signal, Signal[length(Signal)])
    end

    Signal2 = dwt(Signal, wavelet(WT.db2))

    temps = []
    for i in 1:length(Templates_RS_wavelet) #new_Templates_RS new_Templates_RSR new_Templates_QR new_Templates_QRS new_Templates_R new_Templates_Q
        Templates = Templates_RS_wavelet[i]
        push!(temps, (dtw(Signal2, Templates, SqEuclidean(); transportcost = 1)[1], "RS"))
        #Templates = new_Templates_RSR_wavelet[i]
        #push!(temps, (dtw(Signal2, Templates, SqEuclidean(); transportcost = 1)[1], "RSR"))
        Templates = Templates_QR_wavelet[i]
        push!(temps, (dtw(Signal2, Templates, SqEuclidean(); transportcost = 1)[1], "QR"))
        Templates = Templates_QRS_wavelet[i]
        push!(temps, (dtw(Signal2, Templates, SqEuclidean(); transportcost = 1)[1], "QRS"))
        Templates = Templates_R_wavelet[i]
        push!(temps, (dtw(Signal2, Templates, SqEuclidean(); transportcost = 1)[1], "R"))
        Templates = Templates_Q_wavelet[i]
        push!(temps, (dtw(Signal2, Templates, SqEuclidean(); transportcost = 1)[1], "Q"))
    end
    temps_sort = sort!(temps, by = x -> x[1]);

    return temps_sort[1:k]
end




#plot_link = matchplot(Signal, Templates, ds=3, separation=1)





#= СБОР СТАТИСТИКИ =#
NUMBER = 21
BaseName, N = "CSE", NUMBER
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, N)
QRS_start = Ref_qrs[1]
QRS_end = Ref_qrs[2]
Names_files

Channel = 1
L1 = Return_only_complex(const_signal, 1)
L2 = Return_only_complex(const_signal, 2)
L3 = Return_only_complex(const_signal, 3)
L4 = Return_only_complex(const_signal, 4)
L5 = Return_only_complex(const_signal, 5)
L6 = Return_only_complex(const_signal, 6)
L7 = Return_only_complex(const_signal, 7)
L8 = Return_only_complex(const_signal, 8)
L9 = Return_only_complex(const_signal, 9)
L10 = Return_only_complex(const_signal, 10)
L11 = Return_only_complex(const_signal, 11)
L12 = Return_only_complex(const_signal, 12)
ss
function Return_only_complex(const_signal, Channel)
Signal = const_signal[Channel][QRS_start:QRS_end]

w_sort = DTW_kNN(Signal, 13)
Def_complex = defenition_complex(w_sort)[1]
complex = Def_Check(Def_complex, w_sort)

w_sort2 = DTW_plus_Wavelet_kNN(Signal, 13)
Def_complex2 = defenition_complex(w_sort2)[1]
complex2 = Def_Check(Def_complex2, w_sort2)
return complex, complex2
end

#H = check(Def_complex, w_sort2)
#Def_complex[1]
SDADAD


CH


function check(mass, ssort)
    if(mass[1][1] == mass[2][1])
        @info "same"
        if ssort[1][2] !=  mass[1][2]
            return ssort[1][2]
        else
            return mass[1][2]
        end
    else
        @info "No same"
    end
end

check(Def_complex, w_sort2)

Def_complex = defenition_complex(w_sort)[1]

TEST1 = Def_complex = defenition_complex(w_sort)[1]
TEST2 = w_sort = DTW_kNN(Signal, 5)
TEST2[1]
TEST1[1][1]
length(TEST1)




function Def_Check(TEST1, TEST2)

max_length = TEST1[1][1]
mass_max_temps = []
for i in 1:length(TEST1)
    if(TEST1[i][1] == max_length)
        push!(mass_max_temps, TEST1[i][2])
    end
end
mass_max_temps
for i in 1:length(TEST1)
    for j in 1:length(mass_max_temps)
        if (TEST2[i][2] == mass_max_temps[j])
            return mass_max_temps[j]
        end
    end
end
end



#===ТЕСТИРУЕМ ЗАПИСЬ В CSV =#
using CSV, Tables, DataFrames

using CSV
 
# using dataframes package to create a dataframe
using DataFrames 


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
for i in 1:60
NUMBER = i
BaseName = "CSE"
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
QRS_start = Ref_qrs[1]
QRS_end = Ref_qrs[2]
push!(Mass_Names_files, Names_files)
L1 = Return_only_complex(const_signal, 1)
push!(First_ch, L1)
L2 = Return_only_complex(const_signal, 2)
push!(Second_ch, L2)
L3 = Return_only_complex(const_signal, 3)
push!(Third_ch, L3)
L4 = Return_only_complex(const_signal, 4)
push!(Four_ch, L4)
L5 = Return_only_complex(const_signal, 5)
push!(Five_ch, L5)
L6 = Return_only_complex(const_signal, 6)
push!(Six_ch, L6)
L7 = Return_only_complex(const_signal, 7)
push!(Seven_ch, L7)
L8 = Return_only_complex(const_signal, 8)
push!(Eight_ch, L8)
L9 = Return_only_complex(const_signal, 9)
push!(Nine_ch, L9)
L10 = Return_only_complex(const_signal, 10)
push!(Ten_ch, L10)
L11 = Return_only_complex(const_signal, 11)
push!(Eleven_ch, L11)
L12 = Return_only_complex(const_signal, 12)
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
CSV.write("Разметка_k13_0_20.csv", text, delim = ';')


end