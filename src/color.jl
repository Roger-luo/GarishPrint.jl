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

"""
    ColorPreference(;kw...)

See [`pprint`](@ref) for available keyword configurations.
"""
function ColorPreference(;kw...)
    default = supports_color256() ? default_colors_256() : default_colors_ansi()
    colors = merge(default, kw)
    return ColorPreference([colors[name] for name in fieldnames(ColorPreference)]...)
end

"""
    default_colors_ansi()

The default ANSI color theme.
"""
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

"""
    default_colors_256()

The default color 256 theme.
"""
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
