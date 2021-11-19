module NestedSamplers

# load submodules
include("bounds/Bounds.jl")
using .Bounds
include("proposals/Proposals.jl")
using .Proposals

using LinearAlgebra
using Random
using Random: AbstractRNG, GLOBAL_RNG

using AbstractMCMC
using AbstractMCMC: AbstractSampler,
                    AbstractModel,
                    samples,
                    save!!
import AbstractMCMC: step,
                     bundle_samples,
                     mcmcsample
using Distributions: quantile, UnivariateDistribution
using MCMCChains: Chains
using ProgressLogging
import StatsBase
using LogExpFunctions: logaddexp, log1mexp


export Bounds,
       Proposals,
       Models,
       NestedModel,
       Nested

include("model.jl")         # The default model for nested sampling
include("staticsampler.jl") # The static nested sampler
include("step.jl")          # The stepping mechanics (extends AbstractMCMC)
include("sample.jl")        # Custom sampling (extends AbstractMCMC)

include("models/Models.jl")
using .Models

end
