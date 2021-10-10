using Test

@static if VERSION ≥ v"1.6"
    @testset "prefs" begin
        include("prefs.jl")
    end
end

@testset "colors"
    include("colors.jl")
end

include("basic.jl")
include("configs.jl")
include("dataframe.jl")
