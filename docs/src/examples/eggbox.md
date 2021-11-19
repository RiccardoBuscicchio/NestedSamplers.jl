# Eggbox

This example will explore the classic eggbox function using [`Models.Eggbox`](@ref).

## Setup

For this example, you'll need to add the following packages
```julia
julia>]add Distributions MCMCChains Measurements NestedSamplers StatsBase StatsPlots
```

```@setup eggbox
using AbstractMCMC
using Random
AbstractMCMC.setprogress!(false)
Random.seed!(8452)
```

## Define model

```@example eggbox
using NestedSamplers

model, logz = Models.Eggbox()
nothing; # hide
```

let's take a look at a couple of parameters to see what the log-likelihood surface looks like

```@example eggbox
using StatsPlots

x = range(0, 1, length=1000)
y = range(0, 1, length=1000)
logf = [model.loglike([xi, yi]) for yi in y, xi in x]
heatmap(
    x, y, logf,
    xlims=extrema(x),
    ylims=extrema(y),
    xlabel="x",
    ylabel="y",
)
```

## Sample

```@example eggbox
using MCMCChains
using StatsBase
# using multi-ellipsoid for bounds
# using default rejection sampler for proposals
sampler = Nested(2, 500)
chain, state = sample(model, sampler; dlogz=0.01, param_names=["x", "y"])
# resample chain using statistical weights
chain_resampled = sample(chain, Weights(vec(chain[:weights])), length(chain));
nothing # hide
```

## Results

```@example eggbox
chain_resampled
```

```@example eggbox
marginalkde(chain[:x], chain[:y])
plot!(xlims=(0, 1), ylims=(0, 1), sp=2)
plot!(xlims=(0, 1), sp=1)
plot!(ylims=(0, 1), sp=3)
```

```@example eggbox
density(chain_resampled, xlims=(0, 1))
vline!(0.1:0.2:0.9, c=:black, ls=:dash, sp=1)
vline!(0.1:0.2:0.9, c=:black, ls=:dash, sp=2)
```

```@example eggbox
using Measurements
logz_est = state.logz ± state.logzerr
diff = logz_est - logz
println("logz: $logz")
println("estimate: $logz_est")
println("diff: $diff")
nothing # hide
```
