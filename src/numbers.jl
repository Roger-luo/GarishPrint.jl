pprint(io::GarishIO, m::MIME"text/plain", x::Number) = show(io.bland_io, m, x)

# normal literal
function pprint(io::GarishIO, ::MIME"text/plain", x::Union{Int, Float64})
    printstyled(io.bland_io, x; color=io.color.number)
end

function pprint(io::GarishIO, ::MIME"text/plain", x::Float32)
    printstyled(io.bland_io, x; color=io.color.number)
    printstyled(io.bland_io, "f0"; color=io.color.literal)
end

for irrational in [:π, :ℯ, :γ, :ϕ, :catalan]
    @eval function pprint(io::GarishIO, ::MIME"text/plain", ::Irrational{$(QuoteNode(irrational))})
        printstyled(io.bland_io, $(string(irrational)); color=io.color.constant)
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
    printstyled(io.bland_io, "im"; color=io.color.constant)
end
