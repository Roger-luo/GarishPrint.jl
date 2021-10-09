# NOTE: unlike `Base.show` we always ask for explicit MIME type

pprint(x; kw...) = pprint(stdout, x; kw...)
pprint(io::IO, x;kw...) = pprint(io, MIME"text/plain"(), x; kw...)
# wrap other IO with GarishIO
pprint(io::IO, m::MIME, x; kw...) = pprint(GarishIO(io; kw...), m, x)

# Type
pprint(io::GarishIO, mime::MIME, @specialize(x::Type)) = show(io, mime, x)
pprint(io::GarishIO, ::MIME"text/plain", @specialize(x::Type)) = print_token(io, :type, x)

# Struct
function pprint(io::GarishIO, mime::MIME, @nospecialize(x))
    if fallback_to_default_show(io, x) && isstructtype(typeof(x))
        return pprint_struct(io, mime, x)
    elseif io.state.level > 0 # print show inside
        show_text_within(io, mime, x)
    else # fallback to show unless it is a struct type
        show(IOContext(io), mime, x)
    end
end

function show_text_within(io::GarishIO, mime::MIME, x)
    buf = IOBuffer()
    indentation = io.indent * io.state.level + io.state.offset
    new_displaysize = (io.displaysize[1], io.displaysize[2] - indentation)
    
    buf_io = GarishIO(buf, io; limit=true, displaysize=new_displaysize)
    show(buf_io, mime, x)
    raw = String(take!(buf))
    for (k, line) in enumerate(split(raw, '\n'))
        if !(io.state.noindent_in_first_line && k == 1)
            print_indent(io)
        end
        println(io.bland_io, line)
    end
    print_indent(io) # force put a new line at the end
    return
end

function fallback_to_default_show(io::IO, x)
    # NOTE: Base.show(::IO, ::MIME"text/plain", ::Any) forwards to
    # Base.show(::IO, ::Any)

    # check if we are gonna call Base.show(::IO, ::MIME"text/plain", ::Any)
    mt = methods(Base.show, (typeof(io), MIME"text/plain", typeof(x)))
    length(mt.ms) == 1 && any(mt.ms) do method
        method.sig == Tuple{typeof(Base.show), IO, MIME"text/plain", Any}
    end || return false

    # check if we are gonna call Base.show(::IO, ::Any)
    mt = methods(Base.show, (typeof(io), typeof(x)))
    length(mt.ms) == 1 && return any(mt.ms) do method
        method.sig == Tuple{typeof(Base.show), IO, Any}
    end
end
