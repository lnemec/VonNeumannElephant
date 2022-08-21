"""Add noise to the elephant"""

using Distributions

struct Noise{D <: UnivariateDistribution}
    dist::D
end

function plain_string(noise::Noise{<:Normal})
    sprint(show, MIME"text/plain"(), noise)
end

function Base.show(io::IO, noise::Noise)
    dist = noise.dist
    print(io, "Noise(")
    show(io, dist)
    print(io, ")")
end

function Base.show(io::IO, ::MIME"text/plain", noise::Noise{<:Normal})
    dist = noise.dist
    print(io, "Normal Distribution with location: ", dist.μ, " and sigma: ", dist.σ)
end

function Base.show(io::IO, ::MIME"text/plain", noise::Noise{<:SkewNormal})
    dist = noise.dist
    print(io, "Skewed Normal Distribution with location ξ: ",
              dist.ξ, " ,scale ω: ", dist.ω , ", shape α: ", dist.α)
end

function Base.show(io::IO, ::MIME"text/plain", noise::Noise{<:Uniform})
    dist = noise.dist
    print(io, "Continous Uniform Distribution with limit a: ",
              dist.a, " , and b: ", dist.b)
end

Noise(::Type{<:Normal}; loc, scale) = Noise(Normal(loc, scale))
Noise(::Type{<:SkewNormal}; loc, scale, shape) = Noise(SkewNormal(loc, scale, shape))
Noise(::Type{<:Uniform}; a, b) = Noise(Uniform(a, b))


struct noise_param
    noise_type::String
    location::Float64
    scale::Float64
    shape::Float64
end

function set_noise_param(noise_type::String="randn",
                    scale::Float64 = 1.0,
                    shape::Float64 = 2.0)

    location= 0.5 * scale
    np = noise_param(noise_type, location, scale, shape)
    return np
end

function noisy_elephant(elephant::AbstractMatrix, np::noise_param)

    d1 = size(elephant)[1]
    d2 = size(elephant)[2]
    dims = (d1, d2-1 )
    noise = generate_noise(dims, np)
    elephant[:,2:d2] = elephant[:,2:d2] .+ noise

    plot_noise(elephant, noise, np)

    return noise, elephant

end

function generate_noise(dims::Tuple{Int64, Int64}, np)

    N = dims[1]*dims[2]

    if np.noise_type == "randn"
        noise = randn(N).*np.scale
    elseif np.noise_type == "rand"
        noise = rand(N).*np.scale.-np.location
    elseif np.noise_type == "skewed"
        # \xi \, location (real)
        # \omega \, scale (positive, real)
        # \alpha \, shape (real)
        skewed = SkewNormal(0.0, np.scale, np.shape)
        noise = (rand(skewed, N))
    else
        noise = zeros(N)
    end

    noise = reshape(noise, dims)

    return noise
end

function gen_noise(rng::AbstractRNG, dist::UnivariateDistribution, dims)
    rand(rng, dist, dims)
end

gen_noise(rng::AbstractRNG, dist::UnivariateDistribution, dims...) = gen_noise(rng, dist, dims)
gen_noise(dist::UnivariateDistribution, args...) = gen_noise(default_rng(), dist, args...)

function add_noise!(elephant::AbstractMatrix, noise::AbstractMatrix)
    elephant[:, begin + 1:end] .+= noise
end
