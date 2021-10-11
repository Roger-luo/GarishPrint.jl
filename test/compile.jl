using GarishPrint
using GarishPrint: GarishIO, print_token
using Test

struct T1
    x::Int
end

struct T2
    x::Int
    y::Float64
end

struct T3
    x::Int
    y::T1
    z::T2
end

struct T4{T}
    x::T
    y::T
end

struct T5{T}
    x::T
end




# @time pprint(T5(Dict(1=>2)))
# @time GarishIO(stdout)
# @time T2(1, 2)
io = GarishIO(stdout)
# @code_warntype print_token(io, :number, 2)
@time print_token(io, :number, 2)
@time print_token(io, :number, 2.0)
@time print_token(io, :type, "T2")
@time pprint_struct(io, MIME"text/plain"(), T2(1, 2))
# @time pprint(io, MIME"text/plain"(), T2(1, 2))
# @time GarishPrint.pprint_field(GarishIO(stdout), MIME"text/plain"(), T5(Dict(1=>2)).x)
# pprint(GarishIO(stdout), MIME"text/plain"(), Dict(1=>2))
# @time pprint(T5(Dict(1=>2)))
# @code_warntype pprint_struct(GarishIO(stdout), MIME"text/plain"(), T2(1, 2))

