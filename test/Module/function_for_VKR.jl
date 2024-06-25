include("Module_Get_Signal.jl")
using ContinuousWavelets, Wavelets, Distances, DynamicAxisWarping
using Plots, JLD2


function DTW_kNN(Signal, k, Templates_Q, Templates_R, Templates_QR, Templates_QRS, Templates_RS)

    temps = []
    for i in 1:length(Templates_RS) #new_Templates_RS new_Templates_RSR new_Templates_QR new_Templates_QRS new_Templates_R new_Templates_Q
        Templates = Templates_RS[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RS"))
     #   Templates = Templates_RSR_dtw[i]
     #   push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RSR"))
        Templates = Templates_QR[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QR"))
        Templates = Templates_QRS[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QRS"))
        Templates = Templates_R[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "R"))
        Templates = Templates_Q[i]
        push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "Q"))
    end
    temps_sort = sort!(temps, by = x -> x[1]);

    return temps_sort[1:k]
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

function Walvet_sig(Mass_sig)
    new_Massiv1 = copy(Mass_sig)
    new_Massiv2 = []

    for i in 1:length(new_Massiv1)
        if (length(new_Massiv1[i]) %2 == 1)
            push!(new_Massiv1[i], new_Massiv1[i][length(new_Massiv1[i])])
        end

        push!(new_Massiv2, dwt(new_Massiv1[i], wavelet(WT.db2)))

    end

    return new_Massiv2
end



function Result_DTW_Walvet(sig, k, initial_selection_Q_dtw, initial_selection_R_dtw, initial_selection_QR_dtw, initial_selection_QRS_dtw, initial_selection_RS_dtw, initial_selection_Q_walvet, initial_selection_R_walvet, initial_selection_QR_walvet, initial_selection_QRS_walvet, initial_selection_RS_walvet)

    Mass_complex_dtw = DTW_kNN(sig, k, initial_selection_Q_dtw, initial_selection_R_dtw, initial_selection_QR_dtw, initial_selection_QRS_dtw, initial_selection_RS_dtw)
    Def_complex_dtw = defenition_complex(Mass_complex_dtw)[1]
    complex_dtw = Def_Check(Def_complex_dtw, Mass_complex_dtw)
    
    Mass_complex_walvet = DTW_kNN(sig, k, initial_selection_Q_walvet, initial_selection_R_walvet, initial_selection_QR_walvet, initial_selection_QRS_walvet, initial_selection_RS_walvet)
    Def_complex_walvet = defenition_complex(Mass_complex_walvet)[1]
    complex_walvet = Def_Check(Def_complex_walvet, Mass_complex_walvet)
    
    return (complex_dtw, complex_walvet)
end