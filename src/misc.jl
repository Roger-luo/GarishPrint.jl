function pprint(io::GarishIO, ::MIME"text/plain", t::Tuple)
    pprint_list_like(io, t, "(", ")")
end

function pprint(io::GarishIO, ::MIME"text/plain", s::Pair)
    pprint(io, s.first)
    print_operator(io, "=>")
    pprint(io, s.second)
end

function pprint(io::GarishIO, ::MIME"text/plain", bool::Bool)
    Base.with_output_color(show, io.color.constant, io, bool)
end

function pprint(io::GarishIO, ::MIME"text/plain", s::AbstractString)
    Base.with_output_color(show, io.color.string, io, s)
end

pprint(io::GarishIO, ::MIME"text/plain", ::UndefInitializer) = print_undef(io)
pprint(io::GarishIO, ::MIME"text/plain", ::Nothing) = print_nothing(io)
pprint(io::GarishIO, ::MIME"text/plain", ::Missing) = print_missing(io)

function print_nothing(io::GarishIO)
    printstyled(io.bland_io, "nothing"; color=io.color.constant)
end

function print_missing(io::GarishIO)
    printstyled(io.bland_io, "missing"; color=io.color.constant)
end

function print_undef(io::GarishIO)
    printstyled(io.bland_io, "undef"; color=io.color.undef)
end
