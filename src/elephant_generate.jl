"""This function calculates the Fourier components to generate the
von Neuman Elephant"""

const ELEPHANT_PARAMS = @SVector [
    50  - 30im,
    18  + 8im,
    12  - 10im,
    -14 - 60im
]

const ELEPHANT_COEFFS = let ps = ELEPHANT_PARAMS
    @SMatrix [imag(ps[4]) + imag(ps[1])*1im real(ps[1])*1im
             -imag(ps[2])*1im              -real(ps[2])*1im
              imag(ps[3])*1im               real(ps[3]) + 0im
              0 + 0im                       0 + 0im
              0 + 0im                       real(ps[4]) + 0im]
end


function fourier!(out::AbstractMatrix, ts::AbstractVector, coeffs::AbstractVecOrMat)
    size(out, 1) == length(ts) || error("length of out must match length of ts")
    size(out, 2) == size(coeffs, 2) || error("out and coeffs must have same number of columns")

    for (col_idx, col) in enumerate(eachcol(coeffs))
        for (idx, c) in enumerate(col)
            out[:, col_idx] .+= real(c) .* cos.(idx .* ts) .+ imag(c) .* sin.(idx .* ts)
        end
    end
    return out
end

function fourier(ts::AbstractVector, coeffs)
    fourier!(zeros(Float64, (length(ts), size(coeffs, 2))), ts, coeffs)
end

"""Creates a full set of N `len` data points `elephant` between the `start` and
`stop` based on the Fourier reprensentation of the Von Von Neumann Elephant."""
function get_elephant!(elephant::AbstractMatrix, len::Integer, start::Real, stop::Real)
    size(elephant) == (len, 3) || error("elephant arr must have size (len, 3), not $(size(elephant))")

    elephant[:,1] .= range(start; stop=stop, length=len)

    v = @view elephant[:, 2:3]
    fourier!(v, elephant[:,1], ELEPHANT_COEFFS)
    elephant[:,2] .*= -1

    return elephant
end

function get_elephant(len::Integer, start::Real, stop::Real)
    elephant = zeros(Float64, (len, 3))
    get_elephant!(elephant, len, start, stop)
end

"""Selcting a subset of data points `points` from the orginal array
`elephant_full` and the array including noise `elephant_fnoisy` """
function elephant_subset(points::Integer,
                    elephant_fnoisy::AbstractMatrix,
                    elephant_full::AbstractMatrix)

    N_full = size(elephant_full)[1]

    if points == N_full
        elephant = deepcopy(elephant_fnoisy)
        elephant_org = deepcopy(elephant_full)
    else
        idx = rand(1:N_full,points)

        elephant = deepcopy(elephant_fnoisy[idx,:])
        elephant = elephant[sortperm(elephant[:, 1]), :]

        elephant_org = deepcopy(elephant_full[idx,:])
        elephant_org = elephant_org[sortperm(elephant_org[:, 1]), :]
    end
    return elephant, elephant_org
end
