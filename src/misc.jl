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

function pprint(io::GarishIO, ::MIME"text/plain", ::UndefInitializer)
    print_token(io, :undef, "undef")
end

function pprint(io::GarishIO, ::MIME"text/plain", ::Nothing)
    print_token(io, :constant, "nothing")
end

function pprint(io::GarishIO, ::MIME"text/plain", ::Missing)
    print_token(io, :constant, "missing")
end

"""
    print_indent(io::GarishIO)

Print an indentation. This should be only used under `MIME"text/plain"` or equivalent.
"""
function print_indent(io::GarishIO)
    io.compact && return
    io.state.level > 0 || return

    io.show_indent || return print(io, " "^(io.indent * io.state.level))
    for _ in 1:io.state.level
        print_token(io, :comment, "│")
        print(io, " "^(io.indent - 1))
    end
end

"""
    print_operator(io::GarishIO, op)

Print an operator, such as `=`, `+`, `=>` etc. This should be only used under `MIME"text/plain"` or equivalent.
"""
function print_operator(io::GarishIO, op)
    io.compact || print(io, " ")
    print_token(io, :op, op)
    io.compact || print(io, " ")
end
