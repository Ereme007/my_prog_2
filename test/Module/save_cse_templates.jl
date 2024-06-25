include("function_for_VKR.jl")
using Plots
plotly()
import .Module_Get_Signal as m_get_signal


BaseName, NUMBER = "CSE", 1 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
Names_files

plot(const_signal[3][Ref_qrs[1]:Ref_qrs[2]])
Ref_template_CTS = []

TEMPLATES = ("Q", "R", "QR", "QRS", "RS")
#push!(Ref_template_CTS, CAL50000)
count_R, count_Q, count_QR, count_QRS, count_RS = 0, 0, 0, 0, 0
for i in 1:length(Ref_template_CSE)
    for ch in 1:12
        letter = Ref_template_CSE[i][ch]
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


#BaseName, NUMBER = "CTS", 1 #cts это маленькая база, cse -большая база
#Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
#Names_files
#plot((const_signal[2][Ref_QRS_start_CTS[NUMBER]:Ref_QRS_dur_CTS[NUMBER]+Ref_QRS_start_CTS[NUMBER]]))




BaseName, NUMBER = "CSE", 1 #cts это маленькая база, cse -большая база
Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)
#plot((const_signal[1][Ref_qrs[1]:Ref_qrs[2]]))




MO1_001 = ("RS", "RS", "-", "QR",	"QRS", "RS", "QRS", "RS", "RS", "RS", "RS", "RS")
MO1_002 = ("R",	"RS",	"Q",	"Q",	"R",	"QRS",	"Q",	"Q",	"RS",	"RS",	"RS",	"RS")
MO1_003 = ("QRS",	"QRS",	"QRS",	"QR",	"QR",	"QRS",	"QR",	"-",	"RS",	"RS",	"RS",	"RS")
MO1_004 = ("RS",	"QR",	"R",	"Q",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_005 = ("Q",	"RS",	"RS",	"QR",	"Q",	"RS",	"RS",	"RS",	"QRS",	"QRS",	"RS",	"RS")
MO1_006 = ("R",	"QRS",	"QRS",	"QR",	"QR",	"QRS",	"Q",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_007 = ("RS",	"QRS",	"QR",	"Q",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"QRS",	"QRS")
MO1_008 = ("R",	"R",	"QR",	"Q",	"R",	"-",	"RS",	"RS",	"RS",	"RS",	"R",	"R")
MO1_009 = ("RS",	"QRS",	"QR",	"QR",	"QRS",	"Q",	"R",	"-",	"RS",	"RS",	"RS",	"RS")
MO1_010 = ("RS",	"RS",	"RS",	"QR",	"QR",	"RS",	"R",	"R",	"R",	"RS",	"RS",	"RS")
MO1_011 = ("QR",	"R",	"RS",	"Q",	"QR",	"QRS",	"RS",	"RS",	"RS",	"RS",	"R",	"R")
MO1_012 = ("QRS",	"QRS",	"RS",	"QR",	"QR",	"RS",	"Q",	"RS",	"RS",	"RS",	"R",	"R")
MO1_013 = ("QR",	"RS",	"RS",	"QR",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_014 = ("RS",	"RS",	"RS",	"Q",	"QRS",	"RS",	"QR",	"R",	"R",	"RS",	"RS",	"RS")
MO1_015 = ("QRS",	"QR",	"QR",	"Q",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"QR",	"QR")
MO1_016 = ("RS",	"RS",	"RS",	"QR",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_017 = ("R",	"RS",	"Q",	"Q",	"R",	"Q",	"Q",	"Q",	"Q",	"Q",	"RS",	"R")
MO1_018 = ("R",	"RS",	"Q",	"Q",	"R",	"RS",	"Q",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_019 = ("R",	"RS",	"Q",	"QR",	"QR",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_020 = ("R",	"R",	"R",	"Q",	"Q",	"R",	"Q",	"Q",	"Q",	"RS",	"RS",	"R")
MO1_021 = ("QRS",	"RS",	"-",	"Q",	"RS",	"-",	"-",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_022 = ("-",	"RS",	"RS",	"Q",	"Q",	"RS",	"RS",	"RS",	"RS",	"R",	"RS",	"QR")
MO1_023 = ("R",	"R",	"QR",	"Q",	"R",	"RS",	"-",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_024 = ("R",	"R",	"RS",	"Q",	"R",	"RS",	"Q",	"RS",	"RS",	"RS",	"Q",	"R")
MO1_025 = ("R",	"RS",	"RS",	"QR",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS",	"QRS")
MO1_026 = ("R",	"RS",	"Q",	"QR",	"R",	"RS",	"QR",	"QR",	"-",	"RS",	"RS",	"RS")
MO1_027 = ("RS",	"RS",	"RS",	"QR",	"Q",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_028 = ("R",	"R",	"R",	"Q",	"Q",	"R",	"Q",	"Q",	"RS",	"RS",	"RS",	"R")
MO1_029 = ("R",	"R",	"R",	"Q",	"QRS",	"R",	"-",	"-",	"-",	"RS",	"RS",	"R")
MO1_030 = ("R",	"R",	"QR",	"Q",	"RS",	"QR",	"Q",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_031 = ("RS",	"QR",	"QR",	"Q",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"QR",	"QR")
MO1_032 = ("R",	"RS",	"Q",	"Q",	"R",	"Q",	"Q",	"Q",	"Q",	"RS",	"RS",	"R")
MO1_033 = ("RS",	"RS",	"RS",	"QR",	"QR",	"RS",	"QR",	"-",	"RS",	"RS",	"RS",	"RS")
MO1_034 = ("RS",	"R",	"R",	"Q",	"Q",	"R",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_035 = ("RS",	"QR",	"QR",	"QR",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_036 = ("R",	"QRS",	"QR",	"QR",	"R",	"Q",	"RS",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_037 = ("RS",	"RS",	"QR",	"Q",	"RS",	"R",	"RS",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_038 = ("QR",	"RS",	"RS",	"QR",	"QR",	"RS",	"RS",	"RS",	"QRS",	"QRS",	"QRS",	"QR")
MO1_039 = ("QR",	"RS",	"RS",	"QR",	"QR",	"RS",	"Q",	"Q",	"Q",	"Q",	"QRS",	"RS")
MO1_040 = ("R",	"RS",	"Q",	"Q",	"R",	"Q",	"Q",	"Q",	"RS",	"RS",	"RS",	"RS")
MO1_041 = ("QRS",	"RS",	"RS",	"QR",	"QRS",	"RS",	"-",	"-",	"RS",	"QRS",	"QRS",	"QRS")
MO1_042 = ("QR",	"RS",	"RS",	"Q",	"QR",	"RS",	"RS",	"RS",	"RS",	"RS",	"QRS",	"QR")
MO1_043 = ("R",	"QR",	"QR",	"QR",	"R",	"QR",	"RS",	"RS",	"RS",	"RS",	"QRS",	"QR")
MO1_044 = ("R",	"R",	"R",	"Q",	"RS",	"R",	"RS",	"RS",	"RS",	"RS",	"QRS",	"QR")
MO1_045 = ("Q",	"R",	"R",	"QR",	"Q",	"R",	"R",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_046 = ("-",	"RS",	"RS",	"QR",	"-",	"RS",	"Q",	"Q",	"Q",	"RS",	"-",	"-")
MO1_047 = ("Q",	"RS",	"QR",	"QR",	"RS",	"QRS",	"R",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_048 = ("R",	"RS",	"RS",	"QR",	"R",	"RS",	"Q",	"QRS",	"RS",	"RS",	"RS",	"RS")
MO1_049 = ("R",	"QR",	"QR",	"Q",	"RS",	"QR",	"RS",	"RS",	"RS",	"RS",	"R",	"QR")
MO1_050 = ("-",	"R",	"R",	"Q",	"Q",	"R",	"-",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_051 = ("RS",	"RS",	"QR",	"QR",	"RS",	"R",	"QRS",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_052 = ("-",	"RS",	"Q",	"QR",	"-",	"Q",	"Q",	"Q",	"RS",	"RS",	"RS",	"RS")
MO1_053 = ("-",	"-",	"-",	"QR",	"QR",	"-",	"Q",	"RS",	"RS",	"RS",	"RS",	"RS")
MO1_054 = ("R",	"Q",	"Q",	"-",	"R",	"Q",	"Q",	"Q",	"-",	"RS",	"RS",	"RS")
MO1_055 = ("RS",	"QR",	"QR",	"Q",	"Q",	"QR",	"RS",	"RS",	"RS",	"RS",	"QRS",	"QRS")
MO1_056 = ("R",	"R",	"-",	"Q",	"-",	"R",	"Q",	"Q",	"Q",	"RS",	"R",	"R")
MO1_057 = ("R",	"R",	"RS",	"Q",	"-",	"R",	"RS",	"RS",	"RS",	"QRS",	"QR",	"QR")
MO1_058 = ("RS",	"RS",	"QR",	"QR",	"R",	"R",	"RS",	"RS",	"RS",	"RS",	"RS",	"R")
MO1_059 = ("RS",	"QRS",	"QR",	"QR",	"RS",	"QR",	"-",	"RS",	"RS",	"RS",	"QRS",	"QRS")
MO1_060 = ("RS",	"QRS",	"QR",	"QR",	"-",	"QR",	"RS",	"RS",	"RS",	"QRS",	"QR",	"QR")


























count_R, count_Q, count_QR, count_QRS, count_RS = 0, 0, 0, 0, 0
Ref_template_CSE = []


push!(Ref_template_CSE, MO1_001)
push!(Ref_template_CSE, MO1_002)
push!(Ref_template_CSE, MO1_003)
push!(Ref_template_CSE, MO1_004)
push!(Ref_template_CSE, MO1_005)
push!(Ref_template_CSE, MO1_006)
push!(Ref_template_CSE, MO1_007)
push!(Ref_template_CSE, MO1_008)
push!(Ref_template_CSE, MO1_009)
push!(Ref_template_CSE, MO1_010)
push!(Ref_template_CSE, MO1_011)
push!(Ref_template_CSE, MO1_012)
push!(Ref_template_CSE, MO1_013)
push!(Ref_template_CSE, MO1_014)
push!(Ref_template_CSE, MO1_015)
push!(Ref_template_CSE, MO1_016)
push!(Ref_template_CSE, MO1_017)
push!(Ref_template_CSE, MO1_018)
push!(Ref_template_CSE, MO1_019)
push!(Ref_template_CSE, MO1_020)
push!(Ref_template_CSE, MO1_021)
push!(Ref_template_CSE, MO1_022)
push!(Ref_template_CSE, MO1_023)
push!(Ref_template_CSE, MO1_024)
push!(Ref_template_CSE, MO1_025)
push!(Ref_template_CSE, MO1_026)
push!(Ref_template_CSE, MO1_027)
push!(Ref_template_CSE, MO1_028)
push!(Ref_template_CSE, MO1_029)
push!(Ref_template_CSE, MO1_030)
push!(Ref_template_CSE, MO1_031)
push!(Ref_template_CSE, MO1_032)
push!(Ref_template_CSE, MO1_033)
push!(Ref_template_CSE, MO1_034)
push!(Ref_template_CSE, MO1_035)
push!(Ref_template_CSE, MO1_036)
push!(Ref_template_CSE, MO1_037)
push!(Ref_template_CSE, MO1_038)
push!(Ref_template_CSE, MO1_039)
push!(Ref_template_CSE, MO1_040)
push!(Ref_template_CSE, MO1_041)
push!(Ref_template_CSE, MO1_042)
push!(Ref_template_CSE, MO1_043)
push!(Ref_template_CSE, MO1_044)
push!(Ref_template_CSE, MO1_045)
push!(Ref_template_CSE, MO1_046)
push!(Ref_template_CSE, MO1_047)
push!(Ref_template_CSE, MO1_048)
push!(Ref_template_CSE, MO1_049)
push!(Ref_template_CSE, MO1_050)
push!(Ref_template_CSE, MO1_051)
push!(Ref_template_CSE, MO1_052)
push!(Ref_template_CSE, MO1_053)
push!(Ref_template_CSE, MO1_054)
push!(Ref_template_CSE, MO1_055)
push!(Ref_template_CSE, MO1_056)
push!(Ref_template_CSE, MO1_057)
push!(Ref_template_CSE, MO1_058)
push!(Ref_template_CSE, MO1_059)
push!(Ref_template_CSE, MO1_060)

All_templates_Q = []
All_templates_R = []
All_templates_QR = []
All_templates_QRS = []
All_templates_RS = []

count_R, count_Q, count_QR, count_QRS, count_RS = 0, 0, 0, 0, 0
for i in 1:length(Ref_template_CSE)
    BaseName, NUMBER = "CSE", i #cts это маленькая база, cse -большая база
    Names_files, signals_channel, const_signal,  Frequency, koef, Ref_qrs, Ref_P, start_signal, end_signal = m_get_signal.Signal_all_channels(BaseName, NUMBER)

    for ch in 1:12
        letter = Ref_template_CSE[i][ch]
        if letter == "R"
            count_R = count_R+1
            push!(All_templates_R, const_signal[ch][Ref_qrs[1]:Ref_qrs[2]])
        end
        if letter == "Q"
            count_Q = count_Q+1
            push!(All_templates_Q, const_signal[ch][Ref_qrs[1]:Ref_qrs[2]])
        end
        if letter == "QR"
            count_QR = count_QR+1
            push!(All_templates_QR, const_signal[ch][Ref_qrs[1]:Ref_qrs[2]])
        end
        if letter == "QRS"
            count_QRS = count_QRS+1
            push!(All_templates_QRS, const_signal[ch][Ref_qrs[1]:Ref_qrs[2]])
        end
        if letter == "RS"
            count_RS = count_RS+1
            push!(All_templates_RS, const_signal[ch][Ref_qrs[1]:Ref_qrs[2]])
        end
        if letter == "-"
        end
    end
end

count_Q
count_R
count_QR
count_QRS
count_RS

All_templates_Q
All_templates_R
All_templates_QR
All_templates_QRS
All_templates_RS
using JLD2
#@save "save_cse_templates.jld2" All_templates_Q All_templates_R All_templates_QR All_templates_QRS All_templates_RS
@load "save_cse_templates.jld2" All_templates_Q All_templates_R All_templates_QR All_templates_QRS All_templates_RS