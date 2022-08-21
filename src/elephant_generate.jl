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
