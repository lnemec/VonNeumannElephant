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
