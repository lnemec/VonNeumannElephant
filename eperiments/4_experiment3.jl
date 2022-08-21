import VonNeumannElephant as VNE
using CSV, Tables

println("")
println("!!! Run the third experiment and fit the elephant!!!")
println("")

# Define parameters
N_full = 5000
noise_type = ["rand", "randn", "skewed"]
nt_max = size(noise_type)[1]
scale = [1.0, 2.0, 4.0, 8.0]
n_points = [50, 100, 500, 1000]
np_max = size(n_points)[1]

global rmse_data = zeros(Float64, (np_max * nt_max, size(scale)[1]))

elephant_full = VNE.get_elephant(N_full, -pi, pi)

for (idx_nt, nt) in enumerate(noise_type)
    for (idx_np, np) in enumerate(n_points)
        for (idx_sc, sc) in enumerate(scale)

            if nt == "rand"
                sc = sc * 2
            end

            local idx_row = (idx_nt - 1) * np_max + idx_np
            local idx_col = idx_sc


            local noise, elephant_noisy = VNE.noisy_elephant(
                                                       deepcopy(elephant_full),
                                                       VNE.set_noise_param(nt, sc)
                                                       )

            local elephant, elephant_org = VNE.elephant_subset(np,
                                                               elephant_noisy,
                                                               elephant_full)

            local gp = VNE.gp_fit(elephant[:,1], elephant[:,2])

            mae, mse, rmse = VNE.check_quality(elephant_org[:,1],
                                               elephant_org[:,2],
                                               gp)

            rmse_data[idx_row, idx_col] = rmse

        end
        println("Current step: $(nt), $(np)")
    end
end

CSV.write("Experiment_3_rmse_data.csv",
          Tables.table(rmse_data), header=string.(scale))

# https://juliadatascience.io/makie_colors
