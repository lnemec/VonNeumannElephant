import VonNeumannElephant as VNE

println("")
println("!!!Generate and plot the von Neumann elephant!!!")
println("")

# Number of points
N_full = 1000

elephant_full = VNE.get_elephant(N_full, -pi, pi)

VNE.plot_elephant(elephant_full)
VNE.plot_txy(elephant_full)
VNE.FFT_eval(elephant_full)
