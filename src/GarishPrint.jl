module GarishPrint

export pprint, pprint_struct
using Configurations

# 1.0 Compat
@static if !@isdefined(isnothing)
    isnothing(x) = x === nothing
end

@static if VERSION ≥ v"1.6"
    using Preferences
end

@static if VERSION ≥ v"1.6"
    const color_prefs_toml = @load_preference("color")
else
    const color_prefs_toml = nothing
end

include("color.jl")
include("io.jl")
include("pprint.jl")
include("struct.jl")
include("misc.jl")
include("numbers.jl")
include("arrays.jl")
include("dict.jl")
include("set.jl")

end
