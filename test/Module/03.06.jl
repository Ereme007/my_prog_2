using ContinuousWavelets, Plots, Wavelets
x = Int[]
for i in 1:32
    push!(x, i)
end
x_5 = [1, 2, 3, 4, 5]
xt = dwt(x, wt, 5)

xti = idwt(xt, wt, 5)
xti == x

wt
x = range(0, n / 1000, length=n); # 1kHz sampling rate





using Plots
using NearestNeighbors
using Distances

kdtree = KDTree(data)
kdtree2

idxs, dists = knn(kdtree, point, k, true)

idxs
# 3-element Array{Int64,1}:
#  4683
#  6119
#  3278

dists
# 3-element Array{Float64,1}:
#  0.039032201026256215
#  0.04134193711411951
#  0.042974090446474184

# Multiple points
points = rand(3, 4);

idxs, dists = knn(kdtree, points, k, true);

idxs
# 4-element Array{Array{Int64,1},1}:
#  [3330, 4072, 2696]
#  [1825, 7799, 8358]
#  [3497, 2169, 3737]
#  [1845, 9796, 2908]

# dists
# 4-element Array{Array{Float64,1},1}:
#  [0.0298932, 0.0327349, 0.0365979]
#  [0.0348751, 0.0498355, 0.0506802]
#  [0.0318547, 0.037291, 0.0421208]
#  [0.03321, 0.0360935, 0.0411951]

# Static vectors
v = @SVector[0.5, 0.3, 0.2];

idxs, dists = knn(kdtree, v, k, true);

idxs
# 3-element Array{Int64,1}:
#   842
#  3075
#  3046

dists
# 3-element Array{Float64,1}:
#  0.04178677766255837
#  0.04556078331418939
#  0.049967238112417205





using DynamicAxisWarping, Distances, Plots
using DynamicAxisWarping, Plots

fs = 70
t  = range(0,stop=1,step=1/fs)
y0 = sin.(2pi .*t)
y1 = sin.(3pi .*t)
y  = [y0;y1[2:end]] .+ 0.01 .* randn.()
y_2  = [y0;y1[2:end]] .+ 0.01 .* randn.()
q  = [y0;y0[2:end]] .+ 0.01 .* randn.()
y[10:15] .+= 0.5
q[13:25] .+= 0.5

f1 = plot([q y])
f2 = dtwplot(q,y,lc=:green, lw=1)
f3 = matchplot(y,y_22,ds=3,separation=1)
y_22 = y_2[1:130]
q, y, y_22
pp = dtw(y, y_22, SqEuclidean(); transportcost = 1)


plot(f1,f2,f3, legend=false, layout=3, grid=false)




#
using DynamicAxisWarping, Plots, Distances

# Create signals q(u) ∈ ℜ², y(u) ∈ ℜ²
fs = 70
u  = collect(range(0,stop=1,step=1/fs))
# Create a template query signal

q, tq = [sin.(2pi .* u) cos.(2pi .* u)] .+ 0.01 .* randn.(), u
plot(tq, q)




# Create a similar signal
y = [sin.(3pi .*u)  cos.(3pi .* u)] .+ 0.01 .* randn.()
last_peak = findlast(isapprox.(y[:,2], maximum(y[:,2]),atol=0.05))
y, ty = y[1:last_peak, :], u[1:last_peak]
y[end-10:end,:] .+= q[end-10:end,:]
y[10:13] .+= 0.5
plot(ty, y)

# Plot signals
kws = (;linewidth=3, zlabel="index", xlabel="signal comp. 1", ylabel="signal comp. 2",
	   xticks=-1:1:1, yticks=-1:1:1, asepct_ratio=1, legend=nothing)
cs, cq = theme_palette(:auto).colors.colors[1:2]
orig= plot(eachcol(q)...,1:size(q,1); c=cq, label="query", kws...)
plot!(eachcol(y)..., 1:size(y,1) ; c=cs, label="similar signal", kws...)

# Warp 2D time signals and visualize
cost, i1, i2 = dtw(y', q', SqEuclidean(); transportcost = 1)
kws=(;kws..., legend=nothing)
warped=plot(eachcol(q[i2,:])..., 1:length(i2); c=cq, label="query", kws...);
plot!(eachcol(y[i1,:])..., 1:length(i1); c=cs, label="signal", kws..., linewidth=1);
plot(orig, warped)


using NearestNeighbors
using kNN
using DataArrays
using DataFrames
using RDatasets
using Distances

iris = dataset("datasets", "iris")
X = array(iris[:, 1:4])'
y = array(iris[:, 5])
model = knn(X, y, metric = Cityblock())

predict_k1 = predict(model, X, 1)
predict_k2 = predict(model, X, 2)
predict_k3 = predict(model, X, 3)
predict_k4 = predict(model, X, 4)
predict_k5 = predict(model, X, 5)

mean(predict_k1 .== y)
mean(predict_k2 .== y)
mean(predict_k3 .== y)
mean(predict_k4 .== y)
mean(predict_k5 .== y)