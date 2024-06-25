include("function_for_VKR.jl")
using Plots
plotly()
import .Module_Get_Signal as m_get_signal

@load "save_cse_templates.jld2" All_templates_Q All_templates_R All_templates_QR All_templates_QRS All_templates_RS

#Начальная выборка первые 20 штук для каждого класса
#для DTW
initial_selection_Q_1_20_dtw = All_templates_Q[1:20]
initial_selection_R_1_20_dtw = All_templates_R[1:20]
initial_selection_QR_1_20_dtw = All_templates_QR[1:20]
initial_selection_QRS_1_20_dtw = All_templates_QRS[1:20]
initial_selection_RS_1_20_dtw = All_templates_RS[1:20]

#Для Walvet+DTW
initial_selection_Q_1_20_walvet = Walvet_sig(All_templates_Q[1:20])
initial_selection_R_1_20_walvet = Walvet_sig(All_templates_R[1:20])
initial_selection_QR_1_20_walvet = Walvet_sig(All_templates_QR[1:20])
initial_selection_QRS_1_20_walvet = Walvet_sig(All_templates_QRS[1:20])
initial_selection_RS_1_20_walvet = Walvet_sig(All_templates_RS[1:20])
plot!(initial_selection_Q_1_20_walvet[1])
plot(All_templates_R[1])
plot!(initial_selection_R_1_20_walvet[1])
All_templates_Q[1]

#Начальная выборка первые 20 штук для каждого класса
#для DTW
initial_selection_Q_3_32_dtw = All_templates_Q[3:32]
initial_selection_R_3_32_dtw = All_templates_R[3:32]
initial_selection_QR_3_32_dtw = All_templates_QR[3:32]
initial_selection_QRS_3_32_dtw = All_templates_QRS[3:32]
initial_selection_RS_3_32_dtw = All_templates_RS[3:32]

#Для Walvet+DTW
initial_selection_Q_3_32_walvet = Walvet_sig(All_templates_Q[3:32])
initial_selection_R_3_32_walvet = Walvet_sig(All_templates_R[3:32])
initial_selection_QR_3_32_walvet = Walvet_sig(All_templates_QR[3:32])
initial_selection_QRS_3_32_walvet = Walvet_sig(All_templates_QRS[3:32])
initial_selection_RS_3_32_walvet = Walvet_sig(All_templates_RS[3:32])

BaseName, NUMBER = "CSE", 4 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
sig = const_signal[8][Ref_qrs[1]:Ref_qrs[2]]


p1 = plot(All_templates_Q[5], label="signsl")
xlabel!("время мс")
ylabel!("напряжение мкВ")
p2 = plot(initial_selection_Q_1_20_walvet[5], label="wavelet")
xlabel!("время мс")

ylabel!("частота")
#
#Mass_complex_dtw = DTW_kNN(sig, 3, initial_selection_Q_1_20_dtw, initial_selection_R_1_20_dtw, initial_selection_QR_1_20_dtw, initial_selection_QRS_1_20_dtw, initial_selection_RS_1_20_dtw)
#Def_complex_dtw = defenition_complex(Mass_complex_dtw)[1]
#complex_dtw = Def_Check(Def_complex_dtw, Mass_complex_dtw)
#
#Mass_complex_walvet = DTW_kNN(sig, 3, initial_selection_Q_1_20_walvet, initial_selection_R_1_20_walvet, initial_selection_QR_1_20_walvet, initial_selection_QRS_1_20_walvet, initial_selection_RS_1_20_walvet)
#Def_complex_walvet = defenition_complex(Mass_complex_walvet)[1]
#complex_walvet = Def_Check(Def_complex_walvet, Mass_complex_walvet)
#

Result_DTW_Walvet(sig, 3, initial_selection_Q_1_20_dtw, initial_selection_R_1_20_dtw, initial_selection_QR_1_20_dtw, initial_selection_QRS_1_20_dtw, initial_selection_RS_1_20_dtw, initial_selection_Q_1_20_walvet, initial_selection_R_1_20_walvet, initial_selection_QR_1_20_walvet, initial_selection_QRS_1_20_walvet, initial_selection_RS_1_20_walvet)



BaseName, NUMBER = "CSE", 42 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
y2 = const_signal[10][Ref_qrs[1]:Ref_qrs[2]]

y1 = All_templates_QRS[9]

f3 = matchplot(y1,y2,ds=3,separation=1, label = ["template" "signal"])
xlabel!("время мс")
ylabel!("напряжение мкВ")

#Сбор СТАТИСТИКИ
using CSV, Tables, DataFrames


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
K = 9
for i in 1:60
NUMBER = i
BaseName = "CSE"
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
QRS_start = Ref_qrs[1]
QRS_end = Ref_qrs[2]
push!(Mass_Names_files, Names_files)
#L1 = Return_only_complex(const_signal, 1)
L1 = Result_DTW_Walvet(const_signal[1][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(First_ch, L1)

#L2 = Return_only_complex(const_signal, 2)
L2 = Result_DTW_Walvet(const_signal[2][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Second_ch, L2)

#L3 = Return_only_complex(const_signal, 3)
L3 = Result_DTW_Walvet(const_signal[3][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Third_ch, L3)

#L4 = Return_only_complex(const_signal, 4)
L4 = Result_DTW_Walvet(const_signal[4][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Four_ch, L4)

#L5 = Return_only_complex(const_signal, 5)
L5 = Result_DTW_Walvet(const_signal[5][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Five_ch, L5)

#L6 = Return_only_complex(const_signal, 6)
L6 = Result_DTW_Walvet(const_signal[6][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Six_ch, L6)

#L7 = Return_only_complex(const_signal, 7)
L7 = Result_DTW_Walvet(const_signal[7][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Seven_ch, L7)

#L8 = Return_only_complex(const_signal, 8)
L8 = Result_DTW_Walvet(const_signal[8][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Eight_ch, L8)

#L9 = Return_only_complex(const_signal, 9)
L9 = Result_DTW_Walvet(const_signal[9][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Nine_ch, L9)

#L10 = Return_only_complex(const_signal, 10)
L10 = Result_DTW_Walvet(const_signal[10][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Ten_ch, L10)

#L11 = Return_only_complex(const_signal, 11)
L11 = Result_DTW_Walvet(const_signal[11][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
push!(Eleven_ch, L11)

#L12 = Return_only_complex(const_signal, 12)
L12 = Result_DTW_Walvet(const_signal[12][Ref_qrs[1]:Ref_qrs[2]], K, initial_selection_Q_3_32_dtw, initial_selection_R_3_32_dtw, initial_selection_QR_3_32_dtw, initial_selection_QRS_3_32_dtw, initial_selection_RS_3_32_dtw, initial_selection_Q_3_32_walvet, initial_selection_R_3_32_walvet, initial_selection_QR_3_32_walvet, initial_selection_QRS_3_32_walvet, initial_selection_RS_3_32_walvet)
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
CSV.write("test/Module/Summarize/Разметка_k9_3_32.csv", text, delim = ';')
end