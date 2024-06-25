include("Algorithm_DTW.jl")

Templates = [1, 5, 4, 2]
Signal = [1, 2, 4, 1]

Signal = [1, 7, 4, 8, 2, 9, 6, 5, 2, 0]
Templates = [1, 7, 4, 8, 2, 9, 8, 5, 2, 0]
plot([Signal, Templates])
Alg_DTW(Signal, Templates)

array1 = [1, 2, 3, 4, 4, 4, 3, 2, 1]
array2 = [1, 3, 4, 4, 2, 1]
plot([array1, array2], label = ["Q" "P"])
Alg_DTW(array1, array2)
xlabel!("время")
ylabel!("напряжение")


path_DRW(Alg_DTW(array1, array2))


path_DRW(Alg_DTW(Signal, Templates))

Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, DTW(Signal, Templates))


#Сплошное тестирование:
include("Module_Get_Signal.jl")
import .Module_Get_Signal as m_get_signal

include("Module_Fronts.jl")
import .Module_Fronts as m_fronts

include("Module_Edge.jl")
import .Module_Edge as m_edge

include("Module_Plots.jl")
import .Module_Plots as m_plots


using Plots
Ref_QRS_dur=[94, 94, 94, 100, 100, 100, 100, 100, 56, 56, 56, 56, 56, 56, 36, 36, 100, 100]
Ref_QRS_start=[180, 223, 134, 180, 180, 180, 180, 130, 180, 180, 180, 180, 180, 180, 180, 130, 180, 180]
NUMBER = 2
BaseName3, N3 = "CSE", NUMBER
Names_files3, signals_channel3, const_signal3,  Frequency3, koef3, Ref_qrs3, Ref_P3, start_signal3, end_signal3 = m_get_signal.Signal_all_channels(BaseName3, N3)
Names_files3
p1 = plot(signals_channel3[1][1:300])
p2 =plot(signals_channel3[2][1:300])
p3 =plot(signals_channel3[3][1:300])
p4 =plot(signals_channel3[4][1:300])
p5 =plot(signals_channel3[5][1:300])
p6 =plot(signals_channel3[6][1:300])
p7 =plot(signals_channel3[7][1:300])
p8 =plot(signals_channel3[8][1:300])
p9 =plot(signals_channel3[9][1:300])
p10 =plot(signals_channel3[10][1:300])
p11 =plot(signals_channel3[11][1:300])
p12 =plot(signals_channel3[12][1:300])

plot(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12,  layout=(12), legend=false)

plot(signals_channel3[1][(Ref_QRS_start[NUMBER]):(Ref_QRS_start[NUMBER]+Ref_QRS_dur[NUMBER])])
q
#=
Names_files3
Ref_QRS_dur[NUMBER]
#Channel = 2
st1 = signals_channel3[4][(Ref_QRS_start[NUMBER]):(Ref_QRS_start[NUMBER]+Ref_QRS[NUMBER])]


#RS_templates = []
#QR_templates = []
#QRS_templates = []
#RSR_templates = []
#R_templates = []
#Q_templates = []

#push!(R_templates, st1)
#push!(Q_templates, st1)

#push!(RS_templates, st1)
#push!(QR_templates, st1)
#push!(QRS_templates, st1)
#push!(RSR_templates, st1)


R_templates #cut_R_templates
Q_templates #cut_Q_templates
RS_templates #cut_RS_templates
QR_templates #cut_QR_templates
QRS_templates  #cut_QRS_templates
RSR_templates  #cut_RSR_templates


RSR_templates
using JLD2
@save "Templates.jld2" R_templates Q_templates RS_templates QR_templates QRS_templates RSR_templates
@load "Templates.jld2" R_templates Q_templates RS_templates QR_templates QRS_templates RSR_templates


@save "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates
@load "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates


R_templates


RSR_templates132 = copy(RSR_templates)

s = Deleted_same_v(RSR_templates132)
s



cut_RSR_templates = RSR_templates[2:3]

cut_QRS_templates1 = QRS_templates[1:7]
cut_QRS_templates2 = QRS_templates[16:24]
cut_QRS_templates = vcat(cut_QRS_templates1, cut_QRS_templates2)


cut_QR_templates1 = QR_templates[1:4]
cut_QR_templates2 = QR_templates[7:9]
cut_QR_templates = vcat(cut_QR_templates1, cut_QR_templates2)
cut_QR_templates


cut_RS_templates1 = RS_templates[3:10]
cut_RS_templates2 = RS_templates[12]
cut_RS_templates3 = RS_templates[20]
cut_RS_templates4 = RS_templates[22]
cut_RS_templates5 = RS_templates[30]
cut_RS_templates6 = RS_templates[32]
cut_RS_templates7 = RS_templates[40]
cut_RS_templates8 = RS_templates[42]
cut_RS_templates9 = RS_templates[60]
cut_RS_templates10 = RS_templates[62]
cut_RS_templates11 = RS_templates[80]
cut_RS_templates12 = RS_templates[82]
cut_RS_templates13 = RS_templates[90]
cut_RS_templates14 = RS_templates[92]


push!(cut_RS_templates1, cut_RS_templates14)

cut_RS_templates = cut_RS_templates1


R_templates1 = R_templates[2:3]
push!(R_templates1, R_templates[23])

cut_R_templates = R_templates1



Q_templates1 = Q_templates[1:3]
push!(Q_templates1, Q_templates[26])
cut_Q_templates = Q_templates1

Q_templates
qq=26

for i in (qq+1):33
    if Q_templates[qq]==Q_templates[i]
        @info "i = $i"
    end
   #@info QRS_templates[1]==QRS_templates[i]
end




Q_templates[qq]==Q_templates[8]
RS_templates[4]==RS_templates[5]
=#


#================================================#
cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates
Size_templates = length(cut_R_templates) + length(cut_Q_templates) + length(cut_RS_templates) + length(cut_QR_templates) + length(cut_RSR_templates) + length(cut_QRS_templates)
include("Module_Get_Signal.jl")
import .Module_Get_Signal as m_get_signal
using JLD2
@load "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates
NUMBER = 1
BaseName3, N3 = "CSE", NUMBER
Names_files3, signals_channel3, const_signal3,  Frequency3, koef3, Ref_qrs3, Ref_P3, start_signal3, end_signal3 = m_get_signal.Signal_all_channels(BaseName3, N3)
length(cut_RS_templates)
#plot(signals_channel3[1][1:300])
#
Ref_qrs3
QRS_start = Ref_qrs3[1]
QRS_end = Ref_qrs3[2]

signals_channel3[1][QRS_start:QRS_end]


#cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates

include("Algorithm_DTW.jl")
include("Module_Get_Signal.jl")
import .Module_Get_Signal as m_get_signal
using JLD2
@load "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates

NUMBER = 10
BaseName3, N3 = "CSE", NUMBER
Names_files3, signals_channel3, const_signal3,  Frequency3, koef3, Ref_qrs3, Ref_P3, start_signal3, end_signal3 = m_get_signal.Signal_all_channels(BaseName3, N3)
QRS_start = Ref_qrs3[1]
QRS_end = Ref_qrs3[2]
k = [:blue, :red, :green, :black, :blue, :red, :green, :black, :blue, :red, :green, :black]

p = []
for i in 1:12
push!(p, plot(signals_channel3[i][(QRS_start)-5:(QRS_end)+5], color = k[i]))
end
plotly()
plot(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12],  layout=(12), legend=false)



p = []
push!(p, plot(cut_R_templates[1], title=("R")))
push!(p, plot(cut_Q_templates[1],title=("Q")))
push!(p, plot(cut_RS_templates[1], title=("RS")))
push!(p, plot(cut_QR_templates[1], title=("QR")))
push!(p, plot(cut_QRS_templates[1], title=("QRS")))
push!(p, plot(cut_RSR_templates[1], title=("RSR")))

plot(p[1], p[2], p[3], p[4], p[5], p[6], layout=(6), legend=false)

#@load "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates
#cut_QRS_templates
#plot(cut_QRS_templates[16])
#function FFf(Channel)

dwt(x, wt, L=maxtransformlevels(x))
using ContinuousWavelets, Plots, Wavelets
n = 2047;
t = range(0, n / 1000, length=n); # 1kHz sampling rate
f = testfunction(n, "Doppler");
f
pp1 = plot(t, f)
xt = dwt(f, wavelet(WT.db2))
pp2 = plot!(t, xt)
f
xt


ssi = signals_channel3[1][(QRS_start)+14:(QRS_end)-13]
xt = dwt(ssi, wavelet(WT.db2))



plot(ssi)
pp2 = wave_sig = dwt(ssi, wavelet(WT.db2))
ssi
plot!(pp2)
pp = plot(p1)


wt
plot(x)
x

xt_5 = dwt(ssi, wt, 5)
xti_5 = idwt(xt_5, wt, 5)
plot(ssi)
plot!(xti_5)
ssi == xt
xt_1 = dwt(ssi, wt)
plot!(ssi)
plot(xt_5)
plot!(xti_5)
plot!(xt_1)

plot!(xt)

t = dwt(ssi, wavelet(WT.db2))
plot(ssi)
plot!(t)


wt = wavelet(WT.Coiflet{4}(), WT.Filter, WT.Periodic)
# 5 level transform
xt = dwt(ssi, wt, 5)
# inverse tranform
xti = idwt(xt, wt, 5)
# a full transform
xt = dwt(x, wt)




plot(pp1, pp2)

p1 = plot(t, f, legend=false, title="Doppler", xticks=false)
c = wavelet(Morlet(π), β=2)
res = cwt(f, c)


freqs = getMeanFreq(computeWavelets(n, c)[1])
freqs[1] = 0
p2 = heatmap(t, freqs, log.(abs.(res).^2)', xlabel= "time (s)", ylabel="frequency (Hz)", colorbar=false, c=cgrad(:viridis, scale=:log10))
l = @layout [a{.3h};b{.7h}]
plot(p1,p2,layout=l)

# scaling filters is easy
wt = wavelet(WT.haar)
wt = WT.scale(wt, 1/sqrt(2))
# signals can be transformed inplace with a low-level command
# requiring very little memory allocation (especially for L=1 for filters)
dwt!(x, wt, L)      # inplace (lifting)
dwt!(xt, x, wt, L)  # write to xt (filter)

# denoising with default parameters (VisuShrink hard thresholding)
x0 = testfunction(128, "HeaviSine")

x = x0 + 0.3*randn(128)
y = denoise(x)

# plotting utilities 1-d (see images and code in /example)
x = testfunction(128, "Bumps")
y = dwt(x, wavelet(WT.cdf97, WT.Lifting))
d,l = wplotdots(y, 0.1, 128)
A = wplotim(y)
# plotting utilities 2-d
img = imread("lena.png")
x = permutedims(img.data, [ndims(img.data):-1:1])
L = 2
xts = wplotim(x, L, wavelet(WT.db3))




Sig=[]

All_koef_R = []
All_koef_Q = []
All_koef_RS = []
All_koef_QR = []
All_koef_RSR = []
All_koef_QRS = []
Signal = signals_channel3[Channel][QRS_start:QRS_end]

for i in 1:length(cut_R_templates)
    Templates = cut_R_templates[i]
    curr_koeff = Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))
    push!(All_koef_R, curr_koeff)
end

for i in 1:length(cut_Q_templates)
    Templates = cut_Q_templates[i]
    curr_koeff = Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))
    push!(All_koef_Q, curr_koeff)
end

for i in 1:length(cut_RS_templates)
#for i in 7:7
  ##  if (i == 4 || i == 5 || i == 2)

   # else
    Templates = cut_RS_templates[i]
    curr_koeff = Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))
    push!(All_koef_RS, curr_koeff)
    #end
end
length(cut_RS_templates)

for i in 1:length(cut_QR_templates)
    Templates = cut_QR_templates[i]
    curr_koeff = Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))
    push!(All_koef_QR, curr_koeff)
end

for i in 1:length(cut_RSR_templates)
    Templates = cut_RSR_templates[i]
    curr_koeff = Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))
    push!(All_koef_RSR, curr_koeff)
end

#for i in 1:length(cut_QRS_templates)
#include("Algorithm_DTW.jl")
#include("Module_Get_Signal.jl")
#import .Module_Get_Signal as m_get_signal
#using JLD2
#NUMBER = 3
#BaseName3, N3 = "CSE", NUMBER
#Names_files3, signals_channel3, const_signal3,  Frequency3, koef3, Ref_qrs3, Ref_P3, start_signal3, end_signal3 = m_get_signal.Signal_all_channels(BaseName3, N3)
#QRS_start = Ref_qrs3[1]
#QRS_end = Ref_qrs3[2]
Signal = signals_channel3[Channel][QRS_start:QRS_end]
Channel

#Signal1 = signals_channel3[1][QRS_start:QRS_end]

#Signal2 = signals_channel3[2][QRS_start:QRS_end]

#Signal3 = signals_channel3[3][QRS_start:QRS_end]

#Signal = signals_channel3[3][QRS_start:QRS_end]
#@save "Testr_Sig2.jld2" Signal1 Signal2 Signal3
#@load "Testr_Sig2.jld2" Signal1 Signal2 Signal3
#@load "Cut_Templates.jld2" cut_R_templates cut_Q_templates cut_RS_templates cut_QR_templates cut_RSR_templates cut_QRS_templates

#Templates = cut_QRS_templates[11]
#Alg_DTW(Signal, Templates)
#path_DRW(Alg_DTW(Signal, Templates))
#Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))


for i in 1:16
  #  if (i == 11 || i == 3 || i == 1 || i == 9 || i == 7 || i == 15)

    #else
        Templates = cut_QRS_templates[i]
        curr_koeff = Find_koeff2(path_DRW(Alg_DTW(Signal, Templates)), Signal, Templates, Alg_DTW(Signal, Templates))
        push!(All_koef_QRS, curr_koeff)
  #  end
end
length(cut_QRS_templates)

push!(Sig, minimum(All_koef_R))
push!(Sig, minimum(All_koef_Q))
push!(Sig, minimum(All_koef_RS))
push!(Sig, minimum(All_koef_QR))
push!(Sig, minimum(All_koef_RSR))
push!(Sig, minimum(All_koef_QRS))
argmin(Sig)

return argmin(Sig)
end

FFf(1)
FFf(2)
FFf(3)
FFf(4)
FFf(5)
FFf(6)
FFf(7)
FFf(8)
FFf(9)
FFf(10)
FFf(11)
FFf(12)
Names_files3
