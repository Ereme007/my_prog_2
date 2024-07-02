include("../src/Readers.jl")
import .Readers as rd

#Names_files[N], signals, fs, Ref_File

#rd.Signal_all_channels(BaseName, N)
#вывод: Names_files, signals_channel, Const_Signal, Frequency, Ref_qrs
#База "CSE" и "CTS"
BaseName, N = "CTS", 2
BaseName, N = "CSE", 2

Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
if BaseName == "CTS"
    Ref_qrs = [QRS_start_CTS[N], QRS_start_CTS[N]+QRS_dur_CTS[N]]
end
Ref_qrs
signals_channel
plot(signals_channel[1][Ref_qrs[1]:Ref_qrs[2]])
plot(signals_channel[1])

using Plots
Ref_qrs