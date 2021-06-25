pprint_struct(io::IO, ::MIME"text/plain", @nospecialize(x);kw...) = pprint_struct(io, x; kw...)
pprint_struct(io::IO, @nospecialize(x); kw...) = pprint_struct(GarishIO(io; kw...), x)

"""
    pprint_struct(io, ::MIME"text/plain", @nospecialize(x))

Print `x` as a struct type.
"""
function pprint_struct(io::GarishIO, ::MIME"text/plain", @nospecialize(x))
    pprint_struct(io, x)
end

"""
    pprint_struct(io::GarishIO, x)

Print `x` as a struct type with mime type `MIME"text/plain"`.
"""
function pprint_struct(io::GarishIO, @nospecialize(x))
    t = typeof(x)
    print_token(io, :type, t); print(io.bland_io, "(")

    nf = nfields(x)::Int
    nf == 0 && return print(io.bland_io, ")")

    # make sure we can print the type in one line, or we should print it in ...
    # max_indent_reached = io.indent * io.state.level + io.state.offset + length(string(t)) + 2 > io.displaysize[2]
    max_indent_reached(io, length(string(t)) + 2) && return print(io.bland_io, " … )")

    io.compact || println(io.bland_io)
    within_nextlevel(io) do
        for i in 1:nf
            f = fieldname(t, i)
            print_indent(io)
            print_token(io, :fieldname, f)
            if io.compact
                print(io.bland_io, "=")
            else
                print(io.bland_io, " = ")
                io.state.offset = 3 + length(string(f))
            end

            if !isdefined(x, f) # print undef as comment color
                print_undef(io)
            else
                new_io = GarishIO(IOContext(io.bland_io, :limit=>true), io)
                pprint_field(new_io, getfield(x, i))
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
