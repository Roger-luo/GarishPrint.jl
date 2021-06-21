pprint(io::GarishIO, m::MIME"text/plain", x::Number) = show(io.bland_io, m, x)

# normal literal
function pprint(io::GarishIO, ::MIME"text/plain", x::Union{Int, Float64})
    print_token(io, :number, x)
end

function pprint(io::GarishIO, ::MIME"text/plain", x::Float32)
    print_token(io, :number, x)
    print_token(io, :literal, "f0")
end

for irrational in [:π, :ℯ, :γ, :ϕ, :catalan]
    @eval function pprint(io::GarishIO, ::MIME"text/plain", ::Irrational{$(QuoteNode(irrational))})
        print_token(io, :constant, $(string(irrational)))
    end
end

function pprint(io::GarishIO, ::MIME"text/plain", z::Complex)
    re, im = real(z), imag(z)
    iszero(re) || pprint(io, re)

    iszero(re) || print_operator(io, '+')

    # NOTE: don't omit + for imag part
    # this is intentional, we want to be
    # able to tell the type of the value
    # from just printing
    pprint(io, im)
    print_token(io, :constant, "im")
end
