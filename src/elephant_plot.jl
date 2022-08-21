"""This function plot the elephant data"""

using Plots
import StatsFuns: norminvcdf

gr()

function plot_elephant(elephant)
    p = plot(elephant[:,2], elephant[:,3],
             grid=false,
             legend = false,
             title = "Von Neumann Elephant",
             color = "#0044aa",
             showaxis=false,
             xticks=([], []),
             yticks=([], []))

    scatter!([10],[40],
	         markersize=4,
			 markercolor = "#0044aa",
		     markerstrokecolor = "#0044aa")

    savefig(p, "img/VonNeumannElephant.png")
    return p
end

function plot_txy(elephant)

    l = @layout([a{0.1h}; [b c; d e]])

    title = plot(title = "Parametric Plot: Von Neumann Elephant",
                 grid = false,
                 showaxis = false,
				 color = "#0044aa",
                 xticks=([], []),
                 yticks=([], []),
                 bottom_margin = -50Plots.px)

    p1 = plot(elephant[:,2], elephant[:,3], color = "#0044aa")
    scatter!([10],[40],
	         markersize=4,
			 markercolor = "#0044aa",
		     markerstrokecolor = "#0044aa",
			 ylabel="y(t)",
			 xlabel="x(t)")

    p2 = plot(elephant[:,1], elephant[:,3], color = "#0044aa")
    plot!(xticks = ([-π:π:π;], ["-\\pi", "0", "\\pi"]),
	      ylabel="y(t)",
		  xlabel="t")

    p3 = plot(elephant[:,2], elephant[:,1], color = "#0044aa")
    plot!(yticks = ([-π:π:π;], ["-\\pi", "0", "\\pi"]),
	      ylabel="t",
		  xlabel="x(t)")

    p4 = plot(grid = false,
              showaxis=false,
              color = "#0044aa",
              xticks=([], []),
              yticks=([], []))

    p = plot(title, p1, p2, p3, p4,
             layout=l,
             legend = false)

    savefig(p, "img/Parametric-plot-Elephant.png")
    return p
end

function plot_FFTcoeffs(fftcoeffs::AbstractMatrix,
                        idx_coef::Vector{Vector{Integer}},
                        num_period::Integer,
                        N::Integer)

    labels = ["Ak x" "Bk x" "Ak y" "Bk y"]
    markers = [:circle :rtriangle :star5 :diamond]

    x = collect(range(0, step=1/num_period, length=N÷2))
    p = plot(title = "Von Neumann Elephant: \n Values of Fourier Coeffients",
             legend= true)

    for i in range(1;length=size(idx_coef)[1])
        # println("idx_coef", " ", i, " ", idx_coef[i], " ", fftcoeffs[idx_coef[i], i])
        scatter!(x[idx_coef[i]],
                 fftcoeffs[idx_coef[i], i],
                 label=labels[i],
                 m = markers[i])
    end

    ticks = [-60, -30, -14, -10, 0, 8, 12, 18, 50]
    plot!(yticks = (ticks, ticks))
    savefig(p, "img/Fourier-coefficient-values.png")
end

function plot_noise(elephant, noise, np)

    N = size(elephant)[1]

    filename = "img/Noise-Elephant_" * np.noise_type
    t = "The Noisy Elephant " * "\n" * "Noise Type: " * np.noise_type

    if np.scale != 1.0
        t = t * " Scale: " * string(np.scale)
        filename = filename * "_" * string(np.scale)
    end

    if np.noise_type == "skewed"
        t = t * " Shape: " * string(np.shape)
        filename = filename * "_" * string(np.shape)
    end

    filename = filename * ".png"

    if N < 500
        num_bins = 5
    elseif N÷25 < 50
        num_bins = N÷25
    else
        num_bins = 50
    end

    l = @layout([a{0.15h}; [b c; d e]])

    title = plot(title = t,
                 grid = false,
                 showaxis = false,
                 xticks=([], []),
                 yticks=([], []),
                 bottom_margin = -30Plots.px)

    p1 = plot(elephant[:,1],
	          elephant[:,2],
			  title="Data x(t)",
			  color = "#0044aa")
    plot!(xticks = ([-π:π:π;], ["-\\pi", "0", "\\pi"]),
	      xlabel="t",
		  ylabel="x(t)")

    p2 = histogram(noise[:,1],
	               bin=num_bins,
				   normed=true,
				   fillcolor = "#0044aa",
				   title="Noise x",
				   xlabel="Δx")

    p3 = plot(elephant[:,1],
	          elephant[:,3],
			  title="Data y(t)",
			  color = "#0044aa")
    plot!(xticks = ([-π:π:π;], ["-\\pi", "0", "\\pi"]),
	      xlabel="t",
		  ylabel="y(t)")

    p4 = histogram(noise[:,2],
	               bin=num_bins,
				   normed=true,
				   fillcolor = "#0044aa",
				   title="Noise y",
				   xlabel="Δy")

    p = plot(title, p1, p2, p3, p4,
             layout=l, legend =false)
    savefig(p, filename)
end
