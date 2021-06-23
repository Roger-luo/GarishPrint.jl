function pprint(io::GarishIO, ::MIME"text/plain", t::Tuple)
    pprint_list_like(io, t, "(", ")")
end

function pprint(io::GarishIO, ::MIME"text/plain", s::Pair)
    pprint(io, s.first)
    print_operator(io, "=>")
    if !io.compact
        buf = IOBuffer()
        pprint(GarishIO(IOContext(buf, :color=>false), io), s.first)
        io.state.offset = length(String(take!(buf))) + 4
    end

    within_nextlevel(io) do
        upperlevel_type = io.state.type
        upperlevel_noindent_in_first_line = io.state.noindent_in_first_line
        io.state.type = StructField
        io.state.noindent_in_first_line = true    
        pprint(io, s.second)
        io.state.noindent_in_first_line = upperlevel_noindent_in_first_line
        io.state.type = upperlevel_type
    end
    return
end

function pprint(io::GarishIO, ::MIME"text/plain", bool::Bool)
    print_token(show, io, :constant, bool)
end

function pprint(io::GarishIO, ::MIME"text/plain", s::AbstractString)
    print_token(show, io, :string, s)
end

pprint(io::GarishIO, ::MIME"text/plain", ::UndefInitializer) = print_undef(io)
pprint(io::GarishIO, ::MIME"text/plain", ::Nothing) = print_nothing(io)
pprint(io::GarishIO, ::MIME"text/plain", ::Missing) = print_missing(io)

function print_nothing(io::GarishIO)
    print_token(io, :constant, "nothing")
end

function print_missing(io::GarishIO)
    print_token(io, :constant, "missing")
end

function print_undef(io::GarishIO)
    print_token(io, :undef, "undef")
end
