"""
    @enum PrintType

`PrintType` to tell lower level printing some useful context.
Currently only supports `Unknown` and `StructField`.
"""
@enum PrintType begin
    Unknown
    StructField
end

mutable struct PrintState
    type::PrintType
    typeinfo
    noindent_in_first_line::Bool
    level::Int
    # the offset that should be applied
    # to whoever cares, e.g for the field
    # values
    offset::Int
end

PrintState() = PrintState(Unknown, Any, false, 0, 0)

"""
    GarishIO{IO_t <: IO} <: IO

`GarishIO` contains the pretty printing preference and states.

# Members

- `bland_io::IO_t`: the original io.
- `indent::Int`: indentation size.
- `compact::Bool`: whether the printing should be compact.
- `displaysize::Tuple{Int, Int}`: the terminal displaysize.
- `show_indent`: print the indentation hint or not.
- `color`: color preference, either `ColorScheme` or `nothing` for no color.
- `state`: the state of the printer, see [`PrintState`](@ref).
"""
struct GarishIO{IO_t <: IO} <: Base.AbstractPipe
    # the bland io we want look nice
    bland_io::IO_t
    indent::Int
    compact::Bool
    limit::Bool
    displaysize::Tuple{Int, Int}
    show_indent::Bool
    # option type
    include_defaults::Bool
    # use nothing for no color print
    color::Union{Nothing, ColorScheme}
    state::PrintState
end

"""
    GarishIO(io::IO; kw...)

See [`pprint`](@ref) for available keywords.
"""
function GarishIO(io::IO; 
        indent::Int=2,
        compact::Bool=get(io, :compact, false),
        limit::Bool=get(io, :limit, false),
        displaysize::Tuple{Int, Int}=displaysize(io),
        color::Bool=get(io, :color, true),
        color_prefs::Union{Nothing, ColorScheme} = nothing,
        # indent is similar to color
        show_indent::Bool=get(io, :color, true),
        include_defaults::Bool=get(io, :include_defaults, false),
    )

    if color && color_prefs === nothing
        color_prefs = COLOR_SCHEME
    end

    return GarishIO(
        io, indent,
        compact, limit,
        displaysize,
        show_indent,
        include_defaults,
        color_prefs,
        PrintState()
    )
end

function GarishIO(io::GarishIO;
    indent::Int=io.indent,
    compact::Bool=io.compact,
    limit::Bool=io.limit,
    displaysize::Tuple{Int, Int}=io.displaysize,
    show_indent::Bool=io.show_indent,
    include_defaults::Bool=get(io, :include_defaults, false),
    color=io.color,
    state=io.state
    )

    return GarishIO(
        io, indent, compact, limit,
        displaysize, show_indent,
        include_defaults,
        io.color,
        state
    )
end

"""
    GarishIO(io::IO, garish_io::GarishIO; kw...)

Create a new similar `GarishIO` with new bland IO object `io`
based on an existing garish io preference. The preference can
be overloaded by `kw`. See [`pprint`](@ref) for the available
keyword arguments.
"""
function GarishIO(io::IO, garish_io::GarishIO;
        indent::Int=garish_io.indent,
        compact::Bool=garish_io.compact,
        limit::Bool=garish_io.limit,
        displaysize::Tuple{Int, Int}=garish_io.displaysize,
        show_indent::Bool=garish_io.show_indent,
        include_defaults::Bool=get(io, :include_defaults, false),
        color_prefs=garish_io.color,
        state=garish_io.state
    )

    if haskey(io, :color) && io[:color] == false
        color = nothing
    else
        color = garish_io.color
    end

    return GarishIO(
        io, indent,
        compact, limit,
        displaysize,
        show_indent,
        include_defaults,
        color_prefs,
        state,
    )
end

Base.pipe_reader(io::GarishIO) = io.bland_io
Base.pipe_writer(io::GarishIO) = io.bland_io
Base.lock(io::GarishIO) = lock(io.bland_io)
Base.unlock(io::GarishIO) = unlock(io.bland_io)

function Base.IOContext(io::GarishIO, KVs::Pair...)
    IOContext(
        io.bland_io,
        :compact=>io.compact,
        :limit=>io.limit,
        :color=>!isnothing(io.color),
        :displaysize=>io.displaysize,
        :typeinfo=>io.state.typeinfo,

        :pprint_indent=>io.indent,
        :color_preference=>io.color,
        :show_indent=>io.show_indent,
        :include_defaults=>io.include_defaults,
        :pprint_type=>io.state.type,
        :pprint_level=>io.state.level,
        :pprint_offset=>io.state.offset,
        :noindent_in_first_line=>io.state.noindent_in_first_line,

        KVs...
    )
end

Base.displaysize(io::GarishIO) = io.displaysize
Base.in(key_value::Pair, io::GarishIO) = in(key_value, IOContext(io).dict, ===)
Base.haskey(io::GarishIO, key) = haskey(IOContext(io).dict, key)
Base.getindex(io::GarishIO, key) = getindex(IOContext(io).dict, key)
Base.get(io::GarishIO, key, default) = get(IOContext(io).dict, key, default)
Base.keys(io::GarishIO) = keys(IOContext(io).dict)

"""
    within_nextlevel(f, io::GarishIO)

Run `f()` within the next level of indentation where `f` is a function
that print into `io`.
"""
function within_nextlevel(f, io::GarishIO)
    io.state.level += 1
    ret = f()
    io.state.level -= 1

    # upperlevel_type = io.state.type
    #     upperlevel_noindent_in_first_line = io.state.noindent_in_first_line
    #     io.state.type = StructField
    #     io.state.noindent_in_first_line = true    
    #     pprint(io, s.second)
    #     io.state.noindent_in_first_line = upperlevel_noindent_in_first_line
    #     io.state.type = upperlevel_type
    return ret
end

"""
    print_token(io::GarishIO, type::Symbol, xs...)

Print `xs` to a `GarishIO` as given token type. The token type
should match the field name of `ColorScheme`.
"""
function print_token(io::GarishIO, type::Symbol, xs...)
    print_token(print, io, type, xs...)
end

"""
    print_token(f, io::GarishIO, type::Symbol, xs...)

Print `xs` to a `GarishIO` as given token type using `f(io, xs...)`
"""
function print_token(@nospecialize(f), io::GarishIO, type::Symbol, @nospecialize(xs...))
    isnothing(io.color) && return f(io, xs...)
    # workaround :color option
    get(io, :color, false) || return f(io, xs...)
    crayon = getfield(io.color, type)
    # Base.with_output_color
    buf = IOBuffer()
    try f(buf, xs...)
    finally
        str = String(take!(buf))
        return f(io, crayon(str))
    end
end

function max_indent_reached(io::GarishIO, offset::Int)
    io.indent * io.state.level + io.state.offset + offset > io.displaysize[2]
end
