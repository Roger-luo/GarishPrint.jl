module GarishPrint

export pprint, pprint_struct
using Configurations

# 1.0 Compat
@static if !@isdefined(isnothing)
    isnothing(x) = x === nothing
end

include("color.jl")
include("io.jl")
include("pprint.jl")
include("struct.jl")
include("misc.jl")
include("numbers.jl")
include("arrays.jl")
include("dict.jl")
include("set.jl")

# pprint(xs...; kw...) = pprint(stdout, xs...; kw...)

# """
#     pprint([io::IO=stdout, ]xs...; kw...)

# Pretty print given objects `xs` to `io`, default io is `stdout`.

# !!! note

#     `pprint` will detect if an object type has overloaded `Base.show`,
#     and use that if possible, overloading `Base.show` to `GarishPrint`
#     for custom type should use [`pprint_struct`](@ref) to avoid
#     recursive call into `Base.show`.

# # Keyword Arguments

# - `indent::Int`: indent size, default is `2`.
# - `compact::Bool`: whether print withint one line, default is `get(io, :compact, false)`.
# - `displaysize::Tuple{Int, Int}`: the displaysize hint of printed string, note this is not stricted obeyed,
# default is displaysize(io).
# - `show_indent::Bool`: whether print indentation hint, default is `true`.
# - `color::Bool`: whether print with color, default is `true`.

# ## Color Preference

# color preference is available as keyword arguments to override the
# default color scheme. These arguments may take any of the values
# `:normal`, `:default`, `:bold`, `:black`, `:blink`, `:blue`,
# `:cyan`, `:green`, `:hidden`, `:light_black`, `:light_blue`, `:light_cyan`, `:light_green`,
# `:light_magenta`, `:light_red`, `:light_yellow`, `:magenta`, `:nothing`, `:red`, `:reverse`,
# `:underline`, `:white`, or `:yellow` or an integer between 0 and 255 inclusive. Note that
# not all terminals support 256 colors.

# The default color scheme can be checked via `GarishPrint.default_colors_256()` for 256 color,
# and `GarishPrint.default_colors_ansi()` for ANSI color. The 256 color will be used when
# the terminal is detected to support 256 color.

# - `fieldname`: field name of a struct.
# - `type`: the color of a type.
# - `operator`: the color of an operator, e.g `+`, `=>`.
# - `literal`: the color of literals.
# - `constant`: the color of constants, e.g `π`.
# - `number`: the color of numbers, e.g `1.2`, `1`.
# - `string`: the color of string.
# - `comment`: comments, e.g `# some comments`
# - `undef`: the const binding to `UndefInitializer`
# - `linenumber`: line numbers.

# # Notes

# The color print and compact print can also be turned on/off by
# setting `IOContext`, e.g `IOContext(io, :color=>false)` will print
# without color, and `IOContext(io, :compact=>true)` will print within
# one line. This is also what the standard Julia `IO` objects follows
# in printing by default.
# """
# function pprint(io::IO, xs...; kw...)
#     lock(io)
#     try
#         for x in xs
#             pprint(io, x; kw...)
#         end
#     finally
#         unlock(io)
#     end
#     return nothing
# end

# pprint(io::IO, x; kw...) = pprint(io, MIME"text/plain"(), x; kw...)
# pprint(io::GarishIO, x) = pprint(io, MIME"text/plain"(), x)

# """
#     pprint(io::IO, mime::MIME, x; kw...)

# Pretty print an object x with given `MIME` type.

# !!! warning

#     currently only supports `MIME"text/plain"`, the implementation
#     of `MIME"text/html"` is coming soon. Please also feel free to
#     file an issue if you have a desired format wants to support.
# """
# function pprint(io::IO, mime::MIME, x; kw...)
#     # NOTE: color is true by default since it's pprint already
#     pprint(GarishIO(io; color=get(io, :color, true), kw...), mime, x)
# end

# function pprint(io::GarishIO, mime::MIME, @nospecialize(x))
#     if fallback_to_default_show(io, x) && isstructtype(typeof(x))
#         return pprint_struct(io, mime, x)
#     elseif io.state.level > 0 # print show inside
#         show_text_within(io, mime, x)
#     else # fallback to show unless it is a struct type
#         show(wrap_io_context(io), mime, x)
#     end
# end

# function pprint(io::GarishIO, mime::MIME, @specialize(x::Type))
#     show(wrap_io_context(io), mime, x)
# end

# function pprint(io::GarishIO, mime::MIME"text/plain", @specialize(x::Type))
#     print_token(io, :type, x)
# end

# """
#     print_indent(io::GarishIO)

# Print an indentation. This should be only used under `MIME"text/plain"` or equivalent.
# """
# function print_indent(io::GarishIO)
#     io.compact && return
#     io.state.level > 0 || return

#     io.show_indent || return print(io, " "^(io.indent * io.state.level))
#     for _ in 1:io.state.level
#         print_token(io, :comment, "│")
#         print(io, " "^(io.indent - 1))
#     end
# end

# """
#     print_operator(io::GarishIO, op)

# Print an operator, such as `=`, `+`, `=>` etc. This should be only used under `MIME"text/plain"` or equivalent.
# """
# function print_operator(io::GarishIO, op)
#     io.compact || print(io, " ")
#     print_token(io, :operator, op)
#     io.compact || print(io, " ")
# end

# function max_indent_reached(io::GarishIO, offset::Int)
#     io.indent * io.state.level + io.state.offset + offset > io.displaysize[2]
# end

# include("struct.jl")
# include("numbers.jl")
# include("arrays.jl")
# include("dict.jl")
# include("set.jl")
# include("misc.jl")

end
