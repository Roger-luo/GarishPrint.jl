"""
    tty_has_color()

Check if TTY supports color. This is mainly for lower
Julia version like 1.0.
"""
function tty_has_color()
    if isdefined(Base, :get_have_color)
        return Base.get_have_color()
    else
        return Base.have_color
    end
end

"""
    supports_color256()

Check if the terminal supports color 256.
"""
function supports_color256()
    haskey(ENV, "TERM") || return false
    try
        return parse(Int, readchomp(`tput colors 0`)) == 256
    catch
        return false
    end
end

const ColorType = Union{Int, Symbol}

"""
    ColorPreference

The color preference type.
"""
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

struct PreferenceInvalid <: Exception
    key::String
    type
    got
end

function Base.showerror(io::IO, x::PreferenceInvalid)
    print(io, "preference for ")
    printstyled(io, x.key; color=:light_blue)
    print(io, " is invalid, expect ")
    printstyled(io, x.type; color=:green)
    print(io, " got: ", repr(x.got))
end

Base.show(io::IO, x::ColorPreference) = pprint_struct(io, x)

"""
    ColorPreference(;kw...)

See [`pprint`](@ref) for available keyword configurations.
"""
function ColorPreference(;kw...)
    colors = supports_color256() ? default_colors_256() : default_colors_ansi()
    if color_prefs_toml !== nothing
        merge!(colors, color_prefs_toml)
    end
    colors = merge!(colors, kw)

    args = map(fieldnames(ColorPreference)) do name
        val = colors[string(name)]
        if val isa String
            return Symbol(val)
        elseif val isa Int
            return val
        else
            throw(PreferenceInvalid("GarishPrint.color.$name", Union{String, Int}, val))
        end
    end
    return ColorPreference(args...)
end

"""
    default_colors_ansi()

The default ANSI color theme.
"""
function default_colors_ansi()
    Dict{String, Any}(
        "fieldname" => "light_blue",
        "type" => "green",
        "operator" => "normal",
        "literal" => "yellow",
        "constant" => "yellow",
        "number" => "normal",
        "string" => "yellow",
        "comment" => "light_black",
        "undef" => "normal",
        "linenumber" => "light_black",
    )
end

"""
    default_colors_256()

The default color 256 theme.
"""
function default_colors_256()
    Dict{String, Any}(
        "fieldname" => 039,
        "type" => 037,
        "operator" => 196,
        "literal" => 140,
        "constant" => 099,
        "number" => 140,
        "string" => 180,
        "comment" => 240,
        # undef is actually a constant
        "undef" => 099,
        "linenumber" => 240,
    )
end
