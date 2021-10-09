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
pprint(T5(π))
pprint(T5(ℯ))
pprint(T5(fill(π)))

pprint(T5(0.10f0))
pprint(T5("0.10f0"))
pprint(T5(Dict("a"=>2.0, "b"=>2im)))
pprint(T5(Dict("a"=>T4(T5([1, 2, 3]), T5([1, 2, 3])), "b"=>2im)))

pprint(T5(Dict("a"=>(1, 2, 3), "b"=>Any)))

struct ABC{T1, T2, T3}
    hee::T1
    haa::T2
    hoo::T3
end

struct Example{T1, T2}
    field_a::T1
    field_b::T2
    abc::ABC
end

using DataFrames

df = DataFrame(A = 1:4, B = ["M", "F", "F", "M"])

x = Example(
    Dict(
        "a"=>Example(
            [1, 2, 3],
            2.0,
            ABC(1, 2.0im, 3.12f0),
        ),
        "str" => Set([1, 2, 3]),
        "boolean"=> false,
        "missing" => missing,
        "empty set" => Set(),
        "set" => Set([1, 2, 3]),
        "set{any}" => Set(Any[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]),
        "type" => Any,
        "matrix" => rand(10, 10),
        "dataframe" => df,
        "named_tuple" => (name="ABC", age=25),
        "nested" => Example(
            Dict(
                "a"=>Example(
                    [1, 2, 3],
                    2.0,
                    ABC(1, 2.0im, 3.12f0),
                ),
            ),
            undef,
            ABC(nothing, 1.2+2.1im, π),
        )
    ),
    undef,
    ABC(nothing, 1.2+2.1im, π),
)

pprint(x)
pprint(x; color=false)
pprint(x; compact=true)
pprint(x; show_indent=false)

pprint(IOContext(stdout, :color=>false), x)

