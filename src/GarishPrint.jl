module GarishPrint

export pprint

# 1.0 Compat
@static if !@isdefined(isnothing)
    isnothing(x) = x === nothing
end

function tty_has_color()
    if isdefined(Base, :get_have_color)
        return Base.get_have_color()
    else
        return Base.have_color
    end
end

function supports_color256()
    try
        return parse(Int, readchomp(`tput colors`)) == 256
    catch
        return false
    end
end

const ColorType = Union{Int, Symbol}

struct ColorPreference
    fieldname::ColorType
    type::ColorType
    operator::ColorType
    
    # literal-like
    literal::ColorType
    constant::ColorType
    number::ColorType
    string::ColorType

    # comment-like
    comment::ColorType
    undef::ColorType
    linenumber::ColorType
end

function ColorPreference(;kw...)
    default = supports_color256() ? default_colors_256() : default_colors_ansi()
    colors = merge(default, kw)
    return ColorPreference([colors[name] for name in fieldnames(ColorPreference)]...)
end

function default_colors_ansi()
    Dict(
        :fieldname => :light_blue,
        :type => :green,
        :operator => :normal,
        :literal => :yellow,
        :constant => :yellow,
        :number => :normal,
        :string => :yellow,
        :comment => :light_black,
        :undef => :normal,
        :linenumber => :light_black,
    )
end

function default_colors_256()
    Dict(
        :fieldname => 039,
        :type => 037,
        :operator => 196,
        :literal => 140,
        :constant => 099,
        :number => 140,
        :string => 180,
        :comment => 240,
        # undef is actually a constant
        :undef => 099,
        :linenumber => 240,
    )
end

@enum PrintType begin
    Unknown
    StructField
end

mutable struct PrintState
    type::PrintType
    noindent_in_first_line::Bool
    level::Int
end

PrintState() = PrintState(Unknown, false, 0)

struct GarishIO{IO_t <: IO} <: IO
    # the bland io we want look nice
    bland_io::IO_t
    indent::Int
    compact::Bool
    show_indent::Bool
    # use nothing for no color print
    color::Union{Nothing, ColorPreference}
    state::PrintState
end

_write(io::GarishIO, x) = write(IOContext(io.bland_io, :color=>isnothing(io.color), :compact=>io.compact), x)

function within_nextlevel(f, io::GarishIO)
    io.state.level += 1
    ret = f()
    io.state.level -= 1
    return ret
end

Base.write(io::GarishIO, x) = _write(io, x)
Base.write(io::GarishIO, x::UInt8) = _write(io, x)
Base.write(io::GarishIO, x::Char) = _write(io, x)
Base.write(io::GarishIO, x::Array) = _write(io, x)
Base.write(io::GarishIO, x::AbstractArray) = _write(io, x)
Base.write(io::GarishIO, s::AbstractString) = _write(io, s)
Base.write(io::GarishIO, s::Union{SubString{String}, String}) = _write(io, s)

function Base.get(io::GarishIO, key::Symbol, default)
    if key === :indent
        return io.key
    elseif key === :compact
        return io.compact
    elseif key === :color
        return !isnothing(io.color)
    else
        return get(io.bland_io, key, default)
    end
end

function GarishIO(io::IO; 
        indent::Int=2,
        compact::Bool=get(io, :compact, false),
        show_indent::Bool=true,
        color::Bool=true,
        kw...
    )

    if color
        if get(io, :color, false) # force turn on color
            io = IOContext(io, :color=>true)
        end
        color_prefs = ColorPreference(;kw...)
    else
        if get(io, :color, true) # force turn off color
            io = IOContext(io, :color=>false)
        end
        color_prefs = nothing
    end
    return GarishIO(io, indent, compact, show_indent, color_prefs, PrintState())
end

function GarishIO(io::IO, garish_io::GarishIO; indent::Int=garish_io.indent, compact::Bool=garish_io.compact)
    GarishIO(io, indent, compact, garish_io.show_indent, garish_io.color, garish_io.state)
end

pprint(xs...; kw...) = pprint(stdout, xs...; kw...)

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

function pprint(io::IO, mime::MIME, x; kw...)
    # NOTE: color is true by default since it's pprint already
    pprint(GarishIO(io; color=get(io, :color, true), kw...), mime, x)
end

function pprint(io::GarishIO, mime::MIME, @nospecialize(x))
    isstructtype(typeof(x)) && return pprint_struct(io, mime, x)
    # fallback to show unless it is a struct type
    native_io = IOContext(
        io.bland_io,
        :color=>isnothing(io.color),
        :compact=>io.compact,
    )
    return show(native_io, mime, x)
end

function pprint(io::GarishIO, mime::MIME, @specialize(x::Type))
    native_io = IOContext(
        io.bland_io,
        :color=>isnothing(io.color),
        :compact=>io.compact,
    )
    show(native_io, mime, x)
end

function pprint(io::GarishIO, mime::MIME"text/plain", @specialize(x::Type))
    printstyled(io, x; color=io.color.type)
end

function print_indent(io::GarishIO)
    io.compact && return
    io.state.level > 0 || return

    io.show_indent || return print(io, " "^(io.indent * io.state.level))
    for _ in 1:io.state.level
        printstyled(io, "│"; color=io.color.comment)
        print(io, " "^(io.indent - 1))
    end
end

function print_operator(io::GarishIO, op)
    if io.compact
        printstyled(io, op; color=io.color.operator)
    else
        printstyled(io, " ", op, " "; color=io.color.operator)
    end
end

include("struct.jl")
include("numbers.jl")
include("arrays.jl")
include("dict.jl")
include("set.jl")
include("misc.jl")

end