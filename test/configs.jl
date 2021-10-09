module TestConfigs

using Test
using GarishPrint
using Configurations


struct OptionA
    a::Int
    b::Int
end

struct OptionB
    a::Vector{Int}
    b::OptionA
end

Base.show(io::IO, x::OptionA) = GarishPrint.pprint_struct(io, x)
Base.show(io::IO, x::OptionB) = GarishPrint.pprint_struct(io, x)

opt = OptionB([1, 2, 3], OptionA(2, 2))
pprint_struct(opt)

@option "geometry" struct Geometry
    L::Int
    graph::Int
    radius::Float64 = 1.5
end

@option "emulation" struct Emulation
    pulse::String
    algo::String # = "Vern8"
    precision::String # = "float32"
    reltol::Maybe{Float64} = nothing
    abstol::Maybe{Float64} = nothing
    dt::Maybe{Float64} = nothing
    total_time::Vector{Int} = collect(1:7)
    postprocess::Bool = false
    gen_subspace::Bool = false
    geometry::Geometry
end

@option "postprocess" struct PostProcess
    pulse::String
    algo::String
    precision::String
    total_time::Vector{Int} = collect(1:7)
    gen_mappings::Bool=false
    skip_done::Bool=false
    geometry::Geometry
end

@option "cache" struct Cache
    subspace::Maybe{Geometry} = nothing
    postprocess::Maybe{Geometry} = nothing
end

@option struct JobInstance
    project::String
    device::Maybe{Int} = nothing
    emulation::Vector{Emulation} = Emulation[]
    postprocess::Vector{PostProcess} = PostProcess[]
    cache::Vector{Cache} = Cache[]
end

Base.show(io::IO, x::JobInstance) = pprint_struct(io, x; include_defaults=get(io, :include_defaults, false))
Base.show(io::IO, x::Cache) = pprint_struct(io, x; include_defaults=false)
Base.show(io::IO, x::PostProcess) = pprint_struct(io, x; include_defaults=false)
Base.show(io::IO, x::Emulation) = pprint_struct(io, x; include_defaults=false)
Base.show(io::IO, x::Geometry) = pprint_struct(io, x; include_defaults=false)

opt = JobInstance(
    project="test",
    emulation=[
        Emulation(;pulse="linear", algo="Vern8", precision="float32", geometry=Geometry(8, 188, 1.5)),
        Emulation(;pulse="linear", algo="Vern8", precision="float32", geometry=Geometry(8, 188, 1.5)),
    ],
    postprocess=[
        PostProcess(pulse="linear", algo="Vern8", precision="float32", geometry=Geometry(8, 188, 1.5)),
        PostProcess(pulse="linear", algo="Vern8", precision="float32", geometry=Geometry(8, 188, 1.5)),
    ]
)

show(stdout, MIME"text/plain"(), opt)
end
