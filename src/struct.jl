function pprint_struct(io::GarishIO, ::MIME"text/plain", @nospecialize(x))
    t = typeof(x)
    printstyled(io, t; color=io.color.type); print(io.bland_io, "(")

    nf = nfields(x)::Int
    nf == 0 && return print(io.bland_io, ")")

    io.compact || println(io.bland_io)
    within_nextlevel(io) do
        for i in 1:nf
            f = fieldname(t, i)
            print_indent(io)
            printstyled(io.bland_io, f; color=io.color.fieldname)
            if io.compact
                print(io.bland_io, "=")
            else
                print(io.bland_io, " = ")
            end

            if !isdefined(x, f) # print undef as comment color
                print_undef(io)
            else
                pprint_field(io, getfield(x, i))
            end

            if !io.compact || i < nf
                print(io.bland_io, ", ")
            end

            if i < nf
                io.compact || println(io.bland_io)
            end
        end
    end
    io.compact || println(io.bland_io)
    print_indent(io)
    print(io.bland_io, ")")
end

pprint_field(io::GarishIO, x) = pprint_field(io, MIME"text/plain"(), x)

function pprint_field(io::GarishIO, ::MIME"text/plain", x)
    upperlevel_type = io.state.type
    upperlevel_noindent_in_first_line = io.state.noindent_in_first_line
    io.state.type = StructField
    io.state.noindent_in_first_line = true
    pprint(io, x)
    io.state.noindent_in_first_line = upperlevel_noindent_in_first_line
    io.state.type = upperlevel_type
end
