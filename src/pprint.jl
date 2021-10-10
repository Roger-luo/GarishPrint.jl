# NOTE: unlike `Base.show` we always ask for explicit MIME type

"""
    pprint([io::IO=stdout], [mimetype], x; kw...)

Pretty print an object `x` to `io`, default `io` is `stdout`.

!!! note

    `pprint` will detect if an object type has overloaded `Base.show`,
    and use that if possible, overloading `Base.show` to `GarishPrint`
    for custom type should use [`pprint_struct`](@ref) to avoid
    recursive call into `Base.show`.

# Keyword Arguments

- `indent::Int`: indent size, default is `2`.
- `compact::Bool`: whether print withint one line, default is `get(io, :compact, false)`.
- `limit::Bool`: whether the print is limited, default is `get(io, :compact, false)`.
- `displaysize::Tuple{Int, Int}`: the displaysize hint of printed string, note this is not stricted obeyed,
default is `displaysize(io)`.
- `show_indent::Bool`: whether print indentation hint, default is `true`.
- `color::Bool`: whether print with color, default is `true`.

## Keyword Arguments for option struct defined by Configurations

- `include_defaults::Bool`: whether print the default values,
    default is `false` to provide more compact printing in REPL.

## Color Preference

color preference is available as keyword arguments to override the
default color scheme. These arguments may take any of the values
`:normal`, `:default`, `:bold`, `:black`, `:blink`, `:blue`,
`:cyan`, `:green`, `:hidden`, `:light_black`, `:light_blue`, `:light_cyan`, `:light_green`,
`:light_magenta`, `:light_red`, `:light_yellow`, `:magenta`, `:nothing`, `:red`, `:reverse`,
`:underline`, `:white`, or `:yellow` or an integer between 0 and 255 inclusive. Note that
not all terminals support 256 colors.

The default color scheme can be checked via `GarishPrint.default_colors_256()` for 256 color,
and `GarishPrint.default_colors_ansi()` for ANSI color. The 256 color will be used when
the terminal is detected to support 256 color.

- `fieldname`: field name of a struct.
- `type`: the color of a type.
- `operator`: the color of an operator, e.g `+`, `=>`.
- `literal`: the color of literals.
- `constant`: the color of constants, e.g `π`.
- `number`: the color of numbers, e.g `1.2`, `1`.
- `string`: the color of string.
- `comment`: comments, e.g `# some comments`
- `undef`: the const binding to `UndefInitializer`
- `linenumber`: line numbers.

# Notes

The color print and compact print can also be turned on/off by
setting `IOContext`, e.g `IOContext(io, :color=>false)` will print
without color, and `IOContext(io, :compact=>true)` will print within
one line. This is also what the standard Julia `IO` objects follows
in printing by default.
"""
function pprint end

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

    buf_io = GarishIO(buf, io;  limit=true, displaysize=new_displaysize, state=PrintState())
    show(buf_io, mime, x)
    raw = String(take!(buf))
    buf_lines = split(raw, '\n')
    for k in 1:length(buf_lines)-1
        line = buf_lines[k]
        if !(io.state.noindent_in_first_line && k == 1)
            print_indent(io)
        end
        println(io.bland_io, line)
    end

    # pretty print last line
    last_line = buf_lines[end]
    length(buf_lines) == 1 || print_indent(io)
    if endswith(last_line, ')')
        print(io.bland_io, last_line)
    else
        print(io.bland_io, last_line)
        if length(buf_lines) > 1
            println(io)
            print_indent(io) # force put a new line at the end
        end
    end
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
