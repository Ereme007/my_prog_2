include("../src/Readers.jl")
import .Readers as rd

include("../src/DTWfunc.jl")
import .DTWfunc as dtw

#По одному шаблону на каждый класс, без изменений (CTS)
@load "src/Templates/templates_CTS.jld2" Templates_CTS_Q Templates_CTS_QR Templates_CTS_QRS Templates_CTS_RS Templates_CTS_RSR Templates_CTS_R
#По одному шаблону на каждый класс с одинаковым размахом
@load "src/Templates/templates_CTS_scope.jld2" scope_Templates_CTS_Q scope_Templates_CTS_QR scope_Templates_CTS_QRS scope_Templates_CTS_RS scope_Templates_CTS_RSR scope_Templates_CTS_R #Это не обязательно, достаточно применить 2 функции scope(Zeros_signal("TEMPLATES"))
#Несколько шаблонов на каждый класс(неравномерное распределение шаблонов по классу) с одинаковым размахом
@load "src/Templates/scope_More_Templates_CTS.jld2" scope_More_Templates_CTS_Q scope_More_Templates_CTS_QR scope_More_Templates_CTS_QRS scope_More_Templates_CTS_RS scope_More_Templates_CTS_RSR scope_More_Templates_CTS_R

Templates_Q = scope_More_Templates_CTS_Q
Templates_QR = scope_More_Templates_CTS_QR
Templates_QRS = scope_More_Templates_CTS_QRS
Templates_RS = scope_More_Templates_CTS_RS
Templates_RSR = scope_More_Templates_CTS_RSR
Templates_R = scope_More_Templates_CTS_R


#BaseName, N = "CTS", 2
BaseName, N = "CSE", 2

Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
if BaseName == "CTS"
    Ref_qrs = [QRS_start_CTS[N], QRS_start_CTS[N]+QRS_dur_CTS[N]]
end

# function Result_DTW(k, Signal, Q, R, QR, QRS, RS, RSR)
Channel, K = 1, 3
ResultDTW, _ = dtw.Result_DTW(K, rd.scope(rd.Zeros_signal(signals_channel[Channel][Ref_qrs[1]:Ref_qrs[2]])), Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS, Templates_RSR)
ResultDTW