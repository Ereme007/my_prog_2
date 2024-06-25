#Алгорим Alg_DTW из википедии https://ru.wikipedia.org/wiki/Алгоритм_динамической_трансформации_временной_шкалы
function Alg_DTW(Signal, Templates)
    sizeSignal = length(Signal)
    sizeTemplates = length(Templates)
    
    MatrixDistions = fill(0.0, (sizeSignal, sizeTemplates))
    for i in 1:sizeSignal
        for j in 1:sizeTemplates
            MatrixDistions[i, j] = abs(Signal[i] - Templates[j])
        end
    end
    
    MatrixDeformations = fill(1.0, (sizeSignal, sizeTemplates)) #тут небольшое изменение, есть ввероятность ошибки
    for j in 2:sizeTemplates
        MatrixDeformations[1, j] = MatrixDistions[1, j] + MatrixDeformations[1, j-1]
    end
    
    for i in 2:sizeSignal
        MatrixDeformations[i, 1] = MatrixDistions[i, 1] + MatrixDeformations[i-1, 1]
    end

    
    for i in 2:sizeSignal
        for j in 2:sizeTemplates
          MatrixDeformations[i, j] = MatrixDistions[i, j] + min(MatrixDeformations[i-1,j] , MatrixDeformations[i-1,j-1] , MatrixDeformations[i,j-1])
        end
    end
    
    return MatrixDeformations
end


#Оставшиеся функции для определения коэффициента
#делаем путь
function check(Number)
    if Number == 0
        return 1
    else
        return Number
    end
end

function New_position(hight, width, NewMatrix)

    if NewMatrix[hight-1|>check, width-1|>check] < NewMatrix[hight, width-1|>check] && NewMatrix[hight-1|>check, width-1|>check] < NewMatrix[hight-1|>check, width]
        curr_hight = hight-1|>check
        curr_width = width-1|>check
    elseif NewMatrix[hight, width-1|>check] < NewMatrix[hight-1|>check, width]
        curr_hight = hight
        curr_width = width-1|>check
    else
        curr_hight = hight-1|>check
        curr_width = width
    end
        return curr_hight, curr_width
end


function path_DRW(D)
    hight, width = size(D)
    D[1, 1]
    Mass = []
    flag_hight = 0
    flag_width = 0
    while ((hight, width) != (1, 1))
        push!(Mass, New_position(hight, width, D))
        flag_hight = hight
        flag_width = width
        hight, width = New_position(hight, width, D)
        @info "hight = $hight, width = $width"
   #     if (flag_hight == hight) && (flag_width = width)
   #         break;
    #    end
    end
    Mass
    #K = length(Mass)+1
    @info "1 and 15"
    @info "NewMatrix[1, 15] = $D[1, 15]"
    return Mass
end


function summ_K2(Mass, m, n, D)
    summarize = D[n, m]
    i = 1
  #  @info "lastindex(Mass) = $(lastindex(Mass))"
    while (i <= lastindex(Mass))
     #   @info "i = $i, Mass[i] = $(Mass[i])"
        x, y = Mass[i]

        summarize = summarize + D[x, y]
        i = i+1
    end
    return summarize
end

function Find_koeff2(Mass, Q, C, D)
    @info "Mass = $Mass"
    K = length(Mass)+1
    m = length(C)
    n = length(Q)
    return summ_K2(Mass, m, n, D)/K 
end