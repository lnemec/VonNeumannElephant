import VonNeumannElephant as VNE
using CSV, Tables

println("")
println("!!! Run the first experiment and fit the elephant!!!")
println("")

#Define parameters
N_full = 1000
noise_type = "randn"
scale = 2.0
points = [10, 50, 100, 500]

global gp_metrics = zeros(Float64, (size(points)[1],4))

elephant_full = VNE.get_elephant(N_full, -pi, pi)

np = VNE.set_noise_param(noise_type, scale)
noise, elephant_fnoisy = VNE.noisy_elephant(deepcopy(elephant_full), np)

for (idx, ps) in enumerate(points)
    elephant, elephant_org = VNE.elephant_subset(ps, elephant_fnoisy, elephant_full)

    gp = VNE.gp_fit(elephant[:,1], elephant[:,2])

    mae, mse, rmse = VNE.check_quality(elephant_org[:,1],
                                       elephant_org[:,2],
                                       gp)

    N_points = size(elephant)[1]
    filename = "img/GP_$(N_points).png"
    VNE.plot_gp_predict(elephant[:,1], elephant[:,2], gp, filename)
    global gp_metrics[idx,:] = [float(N_points), mae, mse, rmse]
end

CSV.write("Data_GP_metrics.csv",
          Tables.table(gp_metrics),
          header=["N-points", "MAE", "MSE", "RMSE"])
