module Plotting
    include("DTWfunc.jl")
    import .DTWfunc as dtw

    using Plots
    
    #Q, R, QR, QRS, RS, RSR
    function plot_templates(Q, R, QR, QRS, RS, RSR)
        plot_Q = plot(Q, title = "Q")
        plot_QR = plot(QR, title = "QR")
        plot_QRS = plot(QRS, title = "QRS")
        plot_RS = plot(RS, title = "RS")
        plot_RSR = plot(RSR, title = "RSR")
        plot_R = plot(R, title = "R")

        plot(plot_Q,plot_R,plot_QR,plot_QRS,plot_RS,plot_RSR, legend = false)
    end

    function plots_result(K, Sig, Q, R, QR, QRS, RS, RSR)
        Res, _ = dtw.Result_DTW(K, Sig, Q, R, QR, QRS, RS, RSR)
        plot(Sig, legend = false, title = Res)
    end
    export plot_templates, plots_result
end