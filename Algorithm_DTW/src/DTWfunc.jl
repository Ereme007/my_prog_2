module DTWfunc
    using Distances, DynamicAxisWarping
    
    function Result_DTW( Signal,k, Q, R, QR, QRS, RS, RSR)
        Result = DTW_kNN(Signal, k, Q, R, QR, QRS, RS, RSR)
       
        return Result[1][2], Result 
    end

    #Q, R, QR, QRS, RS, RSR
    function DTW_kNN(Signal, k, Q, R, QR, QRS, RS, RSR)

        temps = []
        for i in 1:length(RS) #new_Templates_RS new_Templates_RSR new_Templates_QR new_Templates_QRS new_Templates_R new_Templates_Q
            Templates = RS[i]
            push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RS"))
        end
        for i in 1:length(RSR) 
            Templates = RSR[i]
            push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "RSR"))
        end
        for i in 1:length(QR) 
            Templates = QR[i]
            push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QR"))
        end
        for i in 1:length(QRS) 
            Templates = QRS[i]
            push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "QRS"))
        end
        for i in 1:length(R) 
            Templates = R[i]
            push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "R"))
        end
        for i in 1:length(Q) 
            Templates = Q[i]
            push!(temps, (dtw(Signal, Templates, SqEuclidean(); transportcost = 1)[1], "Q"))
        end
        temps_sort = sort!(temps, by = x -> x[1]);

        return temps_sort[1:k]
    end

    export Result_DTW
end