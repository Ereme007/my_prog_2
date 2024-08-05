module DTWfunc
    using Distances, DynamicAxisWarping
    """
    Функция, определяющая принадлежность к классу (так же выводит классы, которые близки к исходному сигналу в порядке уменьшения схожести) 
    """
    function Result_DTW(k, Signal, Templates)
        Result = DTW_kNN(k, Signal, Templates)
   
        return Result[1][2], Result 
    end
    
    function Result_DTW_with_signal(k, Signal, Templates)
        Result = DTW_kNN(k, Signal, Templates)
   
        return Result[1][2], Result[1][3]
    end

    
    #сделать набор шаблонов. С использрванием map()
    function DTW_kNN(k, Signal, Templates)
        temps = []
        
        map(Templates) do fn
            push!(temps, (dtw(Signal, fn.signal, SqEuclidean(); transportcost = 1)[1], fn.name, fn.signal))
        end
        
        temps_sort = sort!(temps, by = x -> x[1]);

        return temps_sort[1:k]
    end

    export Result_DTW, Result_DTW_with_signal
end