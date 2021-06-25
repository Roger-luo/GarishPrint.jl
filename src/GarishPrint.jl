module GarishPrint

export pprint, pprint_struct

# 1.0 Compat
@static if !@isdefined(isnothing)
    isnothing(x) = x === nothing
end

include("color.jl")
include("io.jl")

"""
    print_token(io::GarishIO, type::Symbol, xs...)

Print `xs` to a `GarishIO` as given token type. The token type
should match the field name of `ColorPreference`.
"""
function print_token(io::GarishIO, type::Symbol, xs...)
    print_token(print, io, type, xs...)
end

"""
    print_token(f, io::GarishIO, type::Symbol, xs...)

Print `xs` to a `GarishIO` as given token type using `f(io, xs...)`
"""
function print_token(f, io::GarishIO, type::Symbol, xs...)
    isnothing(io.color) && return f(io, xs...)
    Base.with_output_color(f, getfield(io.color, type), io, xs...)
end

pprint(xs...; kw...) = pprint(stdout, xs...; kw...)

"""
    pprint([io::IO=stdout, ]xs...; kw...)

Pretty print given objects `xs` to `io`, default io is `stdout`.

!!! note

    `pprint` will detect if an object type has overloaded `Base.show`,
    and use that if possible, overloading `Base.show` to `GarishPrint`
    for custom type should use [`pprint_struct`](@ref) to avoid
    recursive call into `Base.show`.

# Keyword Arguments

- `indent::Int`: indent size, default is `2`.
- `compact::Bool`: whether print withint one line, default is `get(io, :compact, false)`.
- `displaysize::Tuple{Int, Int}`: the displaysize hint of printed string, note this is not stricted obeyed,
default is displaysize(io).
- `show_indent::Bool`: whether print indentation hint, default is `true`.
- `color::Bool`: whether print with color, default is `true`.

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
function pprint(io::IO, xs...; kw...)
    lock(io)
    try
        for x in xs
            pprint(io, x; kw...)
        end
    finally
        unlock(io)
    end
    return nothing
end

pprint(io::IO, x; kw...) = pprint(io, MIME"text/plain"(), x; kw...)
pprint(io::GarishIO, x) = pprint(io, MIME"text/plain"(), x)

"""
    pprint(io::IO, mime::MIME, x; kw...)

Pretty print an object x with given `MIME` type.

!!! warning

    currently only supports `MIME"text/plain"`, the implementation
    of `MIME"text/html"` is coming soon. Please also feel free to
    file an issue if you have a desired format wants to support.
"""
function pprint(io::IO, mime::MIME, x; kw...)
    # NOTE: color is true by default since it's pprint already
    pprint(GarishIO(io; color=get(io, :color, true), kw...), mime, x)
end

function pprint(io::GarishIO, mime::MIME, @nospecialize(x))
    if fallback_to_default_show(io, x) && isstructtype(typeof(x))
        return pprint_struct(io, mime, x)
    elseif io.state.level > 0 # print show inside
        show_text_within(io, mime, x)
    else # fallback to show unless it is a struct type
        show(wrap_io_context(io), mime, x)
    end
end

function show_text_within(io::GarishIO, mime::MIME, x)
    buf = IOBuffer()
    indentation = io.indent * io.state.level + io.state.offset
    new_displaysize = (io.displaysize[1], io.displaysize[2] - indentation)
    buf_io = IOContext(IOContext(buf, wrap_io_context(io)), :limit=>true, :displaysize=>new_displaysize)
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

function pprint(io::GarishIO, mime::MIME, @specialize(x::Type))
    show(wrap_io_context(io), mime, x)
end

function pprint(io::GarishIO, mime::MIME"text/plain", @specialize(x::Type))
    print_token(io, :type, x)
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
    print_token(io, :operator, op)
    io.compact || print(io, " ")
end

function max_indent_reached(io::GarishIO, offset::Int)
    io.indent * io.state.level + io.state.offset + offset > io.displaysize[2]
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


include("struct.jl")
include("numbers.jl")
include("arrays.jl")
include("dict.jl")
include("set.jl")
include("misc.jl")

end
