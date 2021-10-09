module TestDataFrame

using GarishPrint
using DataFrames
using Test

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

end
