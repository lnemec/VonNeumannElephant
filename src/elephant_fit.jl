"""This function fit the data to an elephant"""

using FFTW

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
