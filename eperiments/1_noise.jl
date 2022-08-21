import VonNeumannElephant as VNE

println("")
println("!!! Generate noise!!!")
println("")

# Number of points
N_full = 1000

noise_type = [["rand", 3.0], ["randn", 2.0, 1.0], ["skewed",3.0, 4.0]]

elephant_full = VNE.get_elephant(N_full, -pi, pi)

for (index, value) in enumerate(noise_type)
    n = value[1]
    if n == "rand"
        np = VNE.set_noise_param(n, value[2])
        noise, elephant_fnoisy = VNE.noisy_elephant(deepcopy(elephant_full), np)
    end

    if n == "randn"
        np = VNE.set_noise_param(n, value[2], value[3])
        noise, elephant_fnoisy = VNE.noisy_elephant(deepcopy(elephant_full), np)
    end

    if n == "skewed"
        np = VNE.set_noise_param(n, value[2], value[3])
        noise, elephant_fnoisy = VNE.noisy_elephant(deepcopy(elephant_full), np)
    end
end
