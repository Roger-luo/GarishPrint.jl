function monokai()
    return ColorScheme(
        fieldname = Crayon(foreground = :default),
        type      = Crayon(foreground =  :cyan),

        keyword   = Crayon(foreground = :light_red),
        call      = Crayon(foreground = :cyan),

        text      = Crayon(foreground = :default),
        number    = Crayon(foreground = :magenta),
        string    = Crayon(foreground = :yellow),
        symbol    = Crayon(foreground = :magenta),
        op        = Crayon(foreground = :light_red),
        literal   = Crayon(foreground = :yellow),
        constant  = Crayon(foreground = :yellow),
        
        comment   = Crayon(foreground = :dark_gray),
        undef     = Crayon(foreground = :dark_gray),
        lineno    = Crayon(foreground = :dark_gray),
    )
end

function monokai_256()
    return ColorScheme(;
        fieldname = Crayon(foreground = :default),
        type      = Crayon(foreground =  81),

        keyword   = Crayon(foreground = 197),
        call      = Crayon(foreground =  81),

        text      = Crayon(foreground = :default),
        number    = Crayon(foreground = 141),
        string    = Crayon(foreground = 208),
        symbol    = Crayon(foreground = 141),
        op        = Crayon(foreground = 197),
        literal   = Crayon(foreground = 140),
        constant  = Crayon(foreground =  99),
        
        comment   = Crayon(foreground =  60),
        undef     = Crayon(foreground =  60),
        lineno    = Crayon(foreground =  60),
    )
end
