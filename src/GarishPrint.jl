module GarishPrint

export pprint, pprint_struct
using Configurations

# 1.0 Compat
@static if !@isdefined(isnothing)
    isnothing(x) = x === nothing
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
