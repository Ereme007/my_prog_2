module Stats
    include("Templates/QRS_true.jl")
    include("Readers.jl")
    import .Readers as rd

    include("DTWfunc.jl")
    import .DTWfunc as dtw
    using JLD2, CSV, Tables, DataFrames
    
    @load "src/Templates/All_Templates_map.jld2" All_Templates
    
    function evaluation_classifiers(name, All_Templates, QRS_true, Numer_files, Flag)
        mass_name_templates = ["Q", "QR", "QRS", "RS", "R", "RSR", "-"] 
        Name_test, Q_ref, QR_ref,QRS_ref,RS_ref,R_ref,RSR_ref = [], [], [], [], [], [], []
        Tabel = zeros(Int, (6, 6))
        BaseName = "CSE"
        correct_res = 0
    
        for i in 1:Numer_files
            Names_files, const_signal,  Frequency, Ref_qrs = rd.Signal_all_channels(BaseName, i)
            QRS_start = Ref_qrs[1]
            QRS_end = Ref_qrs[2]
            
            for channel in 1:12
                Signal = const_signal[channel][QRS_start:QRS_end]
                Result, _ = dtw.Result_DTW(1, rd.Processing_Signal(Signal), All_Templates)
                Tester_res = findall(x->x==Result, mass_name_templates)[1]
                Ref_res = findall(x->x==(QRS_true[i][channel]), mass_name_templates)[1]
                
                if Ref_res != 7
                    Tabel[Tester_res, Ref_res] = Tabel[Tester_res, Ref_res] + 1 
                end
            end
        end

        for i in 1:6
            push!(Name_test, mass_name_templates[i])
            push!(Q_ref, Tabel[i, 1])
            push!(QR_ref, Tabel[i, 2])
            push!(QRS_ref,Tabel[i, 3]) 
            push!(RS_ref, Tabel[i, 4])
            push!(R_ref, Tabel[i, 5])
            push!(RSR_ref,Tabel[i, 6]) 
        end
        if Flag == "True"

        text = DataFrame(
            name_TEST = Name_test,
            Q_ref = Q_ref,
            QR_ref = QR_ref,
            QRS_ref = QRS_ref,
            RS_ref = RS_ref,
            R_ref = R_ref,
            RSR_ref = RSR_ref
        )
        CSV.write("scripts/Stats2/$(name).csv", text, delim = ';')
        end
        for i in 1:6
            correct_res = correct_res + Tabel[i, i]
        
        end 
        
        return Tabel, correct_res
    end

    export evaluation_classifiers
end