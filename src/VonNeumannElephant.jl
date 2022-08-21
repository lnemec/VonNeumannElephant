module VonNeumannElephant

    import Base

    using StaticArrays
    using Random
    using Random: default_rng

    Random.seed!(20220821)

    include("elephant_generate.jl")
    include("elephant_plot.jl")
    include("elephant_FFTparam.jl")
    include("elephant_fit.jl")
    include("elephant_noise.jl")

end # module
