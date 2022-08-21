import VonNeumannElephant as VNE
using CSV, Tables

println("")
println("!!! Run the second experiment and fit the elephant!!!")
println("")

#Define parameters
N_full = 1000
noise_type = ["rand", "randn", "skewed"]
scale = 2.0

global gp_metrics = zeros(Float64, (size(noise_type)[1],4))

elephant_full = VNE.get_elephant(N_full, -pi, pi)

for (idx, nt) in enumerate(noise_type)

    if nt == "rand"
        s = scale * 2
    else
        s = scale
    end

    local noise, elephant_noisy = VNE.noisy_elephant(deepcopy(elephant_full),
                                               VNE.set_noise_param(nt, s))

    gp = VNE.gp_fit(elephant_noisy[:,1], elephant_noisy[:,2])

    mae, mse, rmse = VNE.check_quality(elephant_full[:,1],
                                       elephant_full[:,2],
                                       gp)

    filename = "img/GP_$(nt).png"
    VNE.plot_gp_predict(elephant_noisy[:,1], elephant_noisy[:,2], gp, filename)
    global gp_metrics[idx,:] = [float(idx), mae, mse, rmse]
end

CSV.write("Experiment2_GP_metrics.csv",
          Tables.table(gp_metrics),
          header=["Idx_noise-type", "MAE", "MSE", "RMSE"])
