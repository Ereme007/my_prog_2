include("../src/Readers.jl")
import .Readers as rd

#Names_files[N], signals, fs, Ref_File

#rd.Signal_all_channels(BaseName, N)
#вывод: Names_files, signals_channel, Const_Signal, Frequency, Ref_qrs
#База "CSE" и "CTS"
BaseName, N = "CTS", 2
BaseName, N = "CSE", 2

Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)
Ref_qrs


