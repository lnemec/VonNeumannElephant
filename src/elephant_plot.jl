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
