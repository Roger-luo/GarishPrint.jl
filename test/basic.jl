module TestBasic

using GarishPrint
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

struct TTTTTTTTTTTTTTTTTTTT{A,B}
    x::A
    y::B
end

pprint(T1(1))

pprint(T2(1, 2.0))

pprint(T3(1, T1(2), T2(1, 2.0)))

pprint(T4(1+2im, 2im))
pprint(T4(2 + 0im, 2im))

pprint(T5(Any[1, 2, 3]))
pprint(stdout, fill(undef))

T4(T5([1, 2, 3]), T5([1, 2, 3]))|>pprint

pprint(T5(π))

pprint(T5(rand(100)))
pprint(T5(Dict(1=>2)))
pprint(T5(Dict()))
pprint(T5(π))
pprint(T5(ℯ))
pprint(T5(fill(π)))

pprint(T5(0.10f0))
pprint(T5("0.10f0"))
pprint(T5(Dict("a"=>2.0, "b"=>2im)))
pprint(T5(Dict("a"=>T4(T5([1, 2, 3]), T5([1, 2, 3])), "b"=>2im)))

pprint(T5(Dict("a"=>(1, 2, 3), "b"=>Any)))

a = TTTTTTTTTTTTTTTTTTTT(1, 2)
b = TTTTTTTTTTTTTTTTTTTT(a, a)
c = TTTTTTTTTTTTTTTTTTTT(b, b)

pprint(c)

end
