include("../src/Readers.jl")
import .Readers as rd

#Определяем базу и номер сигнала
BaseName, N = "CTS", 2 #имеем базы "CSE" и "CTS"

#Определяем сигнал
Names_files, signals_channel, Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, N)

Ref_qrs #Разметка QRS (в дальнейшем рассматриваем первый комплекс QRS)