include("function_for_VKR.jl")
using Plots
plotly()
import .Module_Get_Signal as m_get_signal


BaseName, NUMBER = "CTS", 1 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files


Ref_QRS_dur_CTS=[94, 94, 94, 100, 100, 100, 100, 100, 56, 56, 56, 56, 56, 56, 36, 36, 100, 100]
Ref_QRS_start_CTS=[180, 223, 134, 180, 180, 180, 180, 130, 180, 180, 180, 180, 180, 180, 180, 130, 180, 180]

plot(signals_channel[1])

Ref_template_CTS = []
ANE20000[7]
ANE20000 = ("QRS","QRS","QRS","RSR","QRS","QRS","RS","RS","RS","QRS","QRS","QRS")
ANE20001 = ("QRS","QRS","QRS","RSR","QRS","QRS","RS","RS","RS","QRS","QRS","QRS")
ANE20002 = ("QRS","QRS","QRS","RSR","QRS","QRS","RS","RS","RS","QRS","QRS","QRS")
CAL05000 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL10000 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL15000 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL20000 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL20002 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL20100 = ("R","R","-","Q","R","R","R","R","R","R","R","R")
CAL20110 = ("R","R","-","Q","R","R","R","R","R","R","R","R")
CAL20160 = ("R","R","-","Q","R","R","R","R","R","R","R","R")
CAL20200 = ("Q","Q","-","R","Q","Q","Q","Q","Q","Q","Q","Q")
CAL20210 = ("Q","Q","-","R","Q","Q","Q","Q","Q","Q","Q","Q")
CAL20260 = ("Q","Q","-","R","Q","Q","Q","Q","Q","Q","Q","-")
CAL20500 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL20502 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL30000 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")
CAL50000 = ("RS","RS","-","QR","RS","RS","RS","RS","RS","RS","RS","RS")

TEMPLATES = ("R", "Q", "QR", "QRS", "RS")
#push!(Ref_template_CTS, CAL50000)
count_R, count_Q, count_QR, count_QRS, count_RS = 0, 0, 0, 0, 0
for i in 1:length(Ref_template_CTS)
    for ch in 1:12
        letter = Ref_template_CTS[i][ch]
        if letter == "R"
            count_R = count_R+1
        end
        if letter == "Q"
            count_Q = count_Q+1
        end
        if letter == "QR"
            count_QR = count_QR+1
        end
        if letter == "QRS"
            count_QRS = count_QRS+1
        end
        if letter == "RS"
            count_RS = count_RS+1
        end
    end
end
#count_R 33; count_Q 32, count_QR 9; count_QRS 24, count_RS 99
xlabel!("время (мс)"), ylabel!("напряжение (мкВ)")
#
BaseName, NUMBER = "CSE", 7 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files
pQRS = plot((const_signal[4][Ref_qrs[1]:Ref_qrs[2]]), title=("QS"), legend=false)
xlabel!("время (мс)")
ylabel!("напряжение (мкВ)")
#
BaseName, NUMBER = "CTS", 12 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files
pQ = plot((const_signal[1][Ref_QRS_start_CTS[NUMBER]:Ref_QRS_dur_CTS[NUMBER]+Ref_QRS_start_CTS[NUMBER]]), title=("QS"), legend=false)
xlabel!("время (мс)")
ylabel!("напряжение (мкВ)")
#
BaseName, NUMBER = "CTS", 11 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files
pR = plot((const_signal[1][Ref_QRS_start_CTS[NUMBER]:Ref_QRS_dur_CTS[NUMBER]+Ref_QRS_start_CTS[NUMBER]]), title=("R"), legend=false)
xlabel!("время (мс)")
ylabel!("напряжение (мкВ)")
#
BaseName, NUMBER = "CTS", 18 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files
pQR = plot((const_signal[4][Ref_QRS_start_CTS[NUMBER]:Ref_QRS_dur_CTS[NUMBER]+Ref_QRS_start_CTS[NUMBER]]), title=("QR"), legend=false)
xlabel!("время (мс)")
ylabel!("напряжение (мкВ)")
#
BaseName, NUMBER = "CTS", 1 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files
pRS = plot((const_signal[7][Ref_QRS_start_CTS[NUMBER]:Ref_QRS_dur_CTS[NUMBER]+Ref_QRS_start_CTS[NUMBER]]), title=("RS"), legend=false )
xlabel!("время (мс)")
ylabel!("напряжение (мкВ)")

plot(pQRS, pQ, pR, pQR, pRS)
xlabel!("время (мс)")
ylabel!("напряжение (мкВ)")







array1 = [1, 2, 3, 4, 4, 4, 3, 2, 1]
array2 = [1, 3, 4, 4, 2, 1]

plot(array1, color = :red, label = "one")
plot!(array2, color = :blue, label = "two")