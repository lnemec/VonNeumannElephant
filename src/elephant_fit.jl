"""This function fit the data to an elephant"""

using FFTW
using Optim
using GaussianProcesses
import Statistics: mean

function fourier_param(elephant::AbstractMatrix)
    fftcoeffs = zeros(size(elephant)[1]÷2,4)
    elephant[:,3] = elephant[:,3]*-1.
    N = size(elephant)[1]
    for i in [2,3]
        # Fourier Transform of the Elephant
        F = fft(elephant[:,i])

        idx = i%2*2+1

        fftcoeffs[:,idx]   =  2/N * real.(F[1:N÷2]) #ak
        fftcoeffs[:,idx+1] = -2/N * imag.(F[1:N÷2]) #bk
    end
    return fftcoeffs
end

function gp_fit(X::Vector{Float64},
                y::Vector{Float64},
                l::Float64 = 8.0,
                s::Float64 = 75.0,
                logObsNoise::Float64 = -0.1*10^-1)

    # Set-up mean and kernel
    # Note that for the Squared exponential
    # kernel the hyperparameters are on the log scale

    # The lengthscale ℓ determines the length of the 'wiggles' in your function.
    # In general, you won't be able to extrapolate more than ℓ units away from
    # your data.
    ℓ = log(π/l)/2.0

    # The output variance determines the average distance of your function away
    # from its mean. Every kernel has this parameter out in front; it's just a
    # scale factor.
    σ = log(s)/2.0

    # log standard deviation of observation noise (this is optional)
    kern = SE(ℓ, σ)
    m = MeanZero()

    # Construct GP
    gp = GP(X, y, m, kern,logObsNoise)
    # plot_gp_predict(X, y, gp, "img/test1.png")

    optimize!(gp)

    return gp

end

function check_quality(X::Vector{Float64},
                       y::Vector{Float64}, gp)

    y_pred, sigma = predict_y(gp, X)
    mae = mean(broadcast(abs, y_pred.-y))
    mse =  mean((y_pred.-y).^2)
    rmse = sqrt.(mse)
    return mae, mse, rmse

end
