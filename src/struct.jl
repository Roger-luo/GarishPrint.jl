"""
    pprint_struct([io::IO=stdout], [mimetype], x; kw...)

Pretty print object `x` that is a struct type (`isstructtype` returns `true`).

# Keyword Arguments

See [`pprint`](@ref), they share the same keyword arguments.
"""
function pprint_struct end

pprint_struct(@nospecialize(x); kw...) = pprint_struct(stdout, x; kw...)

function pprint_struct(io::IO, @nospecialize(x);kw...)
    pprint_struct(GarishIO(io; kw...), x)
end

function pprint_struct(io::GarishIO, @nospecialize(x))
    pprint_struct(io, MIME"text/plain"(), x)
end

"""
    pprint_struct(io, ::MIME"text/plain", @nospecialize(x))

Print `x` as a struct type with mime type `MIME"text/plain"`.
"""
function pprint_struct(io::GarishIO, mime::MIME"text/plain", @nospecialize(x))
    t = typeof(x)
    isstructtype(t) || throw(ArgumentError("expect a struct type, got $t"))
    print_token(io, :type, t); print(io.bland_io, "(")

    nf = nfields(x)::Int
    nf == 0 && return print(io.bland_io, ")")

    # make sure we can print the type in one line, or we should print it in ...
    # max_indent_reached = io.indent * io.state.level + io.state.offset + length(string(t)) + 2 > io.displaysize[2]
    max_indent_reached(io, length(string(t)) + 2) && return print(io.bland_io, " … )")

    io.compact || println(io.bland_io)

    # findout fields to print
    fields_to_print = Int[]
    for i in 1:nf
        f = fieldname(t, i)
        value = getfield(x, i)
        if !io.include_defaults && is_option(x) && value == field_default(t, f)
        else
            push!(fields_to_print, i)
        end
    end

    within_nextlevel(io) do
        for i in fields_to_print
            f = fieldname(t, i)
            value = getfield(x, i)
            print_indent(io)
            print_token(io, :fieldname, f)
            if io.compact
                print(io.bland_io, "=")
            else
                print(io.bland_io, " = ")
                io.state.offset = 3 + length(string(f))
            end

            if !isdefined(x, f) # print undef as comment color
                pprint(io, undef)
            else
                new_io = GarishIO(io; limit=true)
                pprint_field(new_io, mime, value)
            end

            if !io.compact || i != last(fields_to_print)
                print(io.bland_io, ", ")
            end

            if i != last(fields_to_print)
                io.compact || println(io.bland_io)
            end
        end
    end
    io.compact || println(io.bland_io)
    print_indent(io)
    print(io.bland_io, ")")
end

pprint_field(io::GarishIO, @nospecialize(x)) = pprint_field(io, MIME"text/plain"(), x)

function pprint_field(io::GarishIO, mime::MIME"text/plain", @nospecialize(x))
    upperlevel_type = io.state.type
    upperlevel_noindent_in_first_line = io.state.noindent_in_first_line
    io.state.type = StructField
    io.state.noindent_in_first_line = true
    pprint(io, mime, x)
    io.state.noindent_in_first_line = upperlevel_noindent_in_first_line
    io.state.type = upperlevel_type
end
