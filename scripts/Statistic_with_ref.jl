include("../src/Readers.jl")
import .Readers as rd

include("../src/DTWfunc.jl")
import .DTWfunc as dtw

include("../src/Plotting.jl")
import .Plotting as pl
using JLD2
@load "src/Templates/All_Templates_map.jld2" All_Templates


include("../src/Templates/QRS_true.jl") 


include("../src/Stats.jl")
import .Stats as st
Numer_files = 60
New_Tabel, res = st.evaluation_classifiers("Stats_evaluation", All_Templates, MO, Numer_files)
res