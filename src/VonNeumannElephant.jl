module VonNeumannElephant

    import Base

    using StaticArrays
    using Random
    using Random: default_rng

    Random.seed!(20220821)

    include("elephant_generate.jl")
    include("elephant_plot.jl")

end # module
