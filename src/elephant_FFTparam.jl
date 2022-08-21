"""Extract the Fourier coefficients from the array elephant[t,x,y]"""

using FFTW

function FFT_eval(elephant::AbstractMatrix, plot_data::Bool=true)

    N = size(elephant)[1]

    diff_t = maximum(elephant[:,1]) - minimum(elephant[:,1])
    num_period = Int(round(diff_t/pi/2))

    fftcoeffs = fourier_param(elephant)
    idx_coef = extract_idx(fftcoeffs)

    if plot_data
        plot_FFTcoeffs(fftcoeffs, idx_coef, num_period, N)
    end

end

function extract_idx(fftcoeffs::AbstractMatrix, limit::Float64=0.7)
   idx_coef = Array{Array{Integer,1},1}()
   for i in range(1;length=4)
       idx = findall(abs.(fftcoeffs[:,i]) .> limit)
       push!(idx_coef, idx)
   end
   return idx_coef
end
