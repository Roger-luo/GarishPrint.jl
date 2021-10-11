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

# NOTE: this type immutable because each object maps to
# an preference file, thus it shouldn't be changed once
# created

"""
    ColorScheme

The color scheme type.
"""
@option struct ColorScheme
    # struct components
    fieldname::Crayon
    type::Crayon

    # keyword-like
    keyword::Crayon
    call::Crayon

    # literal-like
    text::Crayon
    number::Crayon
    string::Crayon
    symbol::Crayon
    literal::Crayon
    constant::Crayon
    op::Crayon

    # comment-like
    comment::Crayon
    undef::Crayon
    lineno::Crayon
end

# fancy color names
const semantic_crayons = Dict{Crayon, String}()
const semantic_colornames = [
    "default", "black", "blue",
    "cyan", "green", "light_blue", "light_cyan", "light_green",
    "light_magenta", "light_red", "light_yellow", "magenta", "nothing", "red",
    "white"
]

const COLORS = Dict(
     0 => "black",
     1 => "red",
     2 => "green",
     3 => "yellow",
     4 => "blue",
     5 => "magenta",
     6 => "cyan",
     7 => "light_gray",
     9 => "default",
    60 => "dark_gray",
    61 => "light_red",
    62 => "light_green",
    63 => "light_yellow",
    64 => "light_blue",
    65 => "light_magenta",
    66 => "light_cyan",
    67 => "white" 
)

for name in semantic_colornames
    semantic_crayons[Crayon(foreground = Symbol(name))] = name
end

function Configurations.convert_to_option(::Type{ColorScheme}, ::Type{Crayon}, x::String)
    x in semantic_colornames || throw(ArgumentError("invalid color $x"))
    return Crayon(foreground = Symbol(x))
end

function Configurations.convert_to_option(::Type{ColorScheme}, ::Type{Crayon}, d::Dict)
    kwargs = []
    if haskey(d, "foreground")
        push!(kwargs, :foreground => parse_color(d["foreground"]))
    end

    if haskey(d, "background")
        push!(kwargs, :background => parse_color(d["background"]))
    end

    for key in [
            :reset,
            :bold,
            :faint,
            :italics,
            :underline,
            :blink,
            :negative,
            :conceal,
            :strikethrough,
        ]

        if get(d, string(key), false)
            push!(kwargs, key => true)
        end
    end
    return Crayon(;kwargs...)
end

function Configurations.to_dict(::Type{ColorScheme}, x::Crayon)
    if haskey(semantic_crayons, x)
        return semantic_crayons[x]
    else
        d = Dict{String, Any}()
        if x.fg.active
            d["foreground"] = ansi_color_to_dict(x.fg)
        end

        if x.bg.active
            d["background"] = ansi_color_to_dict(x.bg)
        end

        for f in fieldnames(Crayon)
            if f === :fg || f === :bg
                continue
            end

            if getfield(x, f).active
                d[string(each)] = true
            end
        end
        return d
    end
end

parse_color(s::String) = Symbol(s)

function parse_color(d::Dict)
    haskey(d, "style") || error("field `style` is required for color")
    haskey(d, "color") || error("field `color` is required for color")

    if d["style"] == "256"
        return Int(d["color"])
    elseif d["style"] == "24bit"
        return parse(UInt32, "0x" * d["color"])
    else
        error("invalid style: $(d["style"])")
    end
end

function ansi_color_to_dict(x::Crayons.ANSIColor)
    if x.style == Crayons.COLORS_16
        return COLORS[x.r]
    elseif x.style == Crayons.COLORS_256
        Dict{String, Any}(
            "color" => x.r,
            "style" => "256",
        )
    elseif x.style == Crayons.COLORS_24BIT
        Dict{String, Any}(
            "color" => rgb_to_hex(x.r, x.g, x.b),
            "style" => "24bit",
        )
    else
        error("invalid color encoding RESET")
    end
end

function rgb_to_hex(r, g, b)
    r, g, b = UInt32(r), UInt32(g), UInt32(b)
    hex = r << 16 | g << 8 | b
    return uppercase(string(hex; base=16))
end

Base.show(io::IO, x::ColorScheme) = pprint_struct(io, x)

function color_scheme()
    colors = supports_color256() ? monokai_256() : monokai()
    if color_prefs_toml !== nothing
        d = to_dict(colors, TOMLStyle)
        merge!(d, color_prefs_toml)
        return from_dict(ColorScheme, d)
    else
        return colors
    end
end
