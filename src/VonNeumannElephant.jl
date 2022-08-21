module VonNeumannElephant

    # import Distributions: mean, pdf, domain
    import Base

    using StaticArrays
    using Random
    using Random: default_rng

    Random.seed!(20220821)

    include("elephant_generate.jl")

end # module
