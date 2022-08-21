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
