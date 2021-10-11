# Use
#    @warnpcfail precompile(args...)
# if you want to be warned when a precompile directive fails
macro warnpcfail(ex::Expr)
    modl = __module__
    file = __source__.file === nothing ? "?" : String(__source__.file)
    line = __source__.line
    quote
        $(esc(ex)) || @warn """precompile directive
     $($(Expr(:quote, ex)))
 failed. Please report an issue in $($modl) (after checking for duplicates) or remove this directive.""" _file=$file _line=$line
    end
end


function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    isdefined(GarishPrint, Symbol("##pprint_struct#15")) && precompile(Tuple{GarishPrint.var"##pprint_struct#15", Base.Pairs{Symbol, Bool, Tuple{Symbol}, NamedTuple{(:include_defaults,), Tuple{Bool}}}, typeof(GarishPrint.pprint_struct), Base.TTY, Int})

    precompile(Tuple{typeof(GarishPrint.color_scheme)})
    precompile(Tuple{typeof(GarishPrint.fallback_to_default_show), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, NamedTuple{(:name, :age), Tuple{String, Int64}}})
    precompile(Tuple{typeof(GarishPrint.monokai_256)})
    precompile(Tuple{typeof(GarishPrint.parse_color), Base.Dict{String, Any}})
    precompile(Tuple{typeof(GarishPrint.parse_color), String})
    precompile(Tuple{typeof(GarishPrint.pprint), Base.TTY, Array{UndefInitializer, 0}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Array{Float64, 2}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Base.Complex{Int64}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Base.Missing})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Base.Set{Any}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Base.Set{Int64}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Bool})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Float64})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Int64})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, NamedTuple{(:name, :age), Tuple{String, Int64}}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Tuple{Int64, Int64, Int64}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Type})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.TTY}, Base.Multimedia.MIME{Symbol("text/plain")}, Array{UndefInitializer, 0}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.TTY}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{Base.TTY}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}}}, Base.Multimedia.MIME{Symbol("text/plain")}, String})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Array{Int64, 1}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Base.Dict{String, Any}})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Float64})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Base.Multimedia.MIME{Symbol("text/plain")}, UndefInitializer})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.TTY}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.TTY}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.TTY}}, Base.Multimedia.MIME{Symbol("text/plain")}, String})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.TTY}}, Base.Multimedia.MIME{Symbol("text/plain")}, UndefInitializer})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{GarishPrint.GarishIO{Base.GenericIOBuffer{Array{UInt8, 1}}}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint), GarishPrint.GarishIO{GarishPrint.GarishIO{GarishPrint.GarishIO{Base.GenericIOBuffer{Array{UInt8, 1}}}}}, Base.Multimedia.MIME{Symbol("text/plain")}, String})
    precompile(Tuple{typeof(GarishPrint.pprint_struct), Base.TTY, Int})
    precompile(Tuple{typeof(GarishPrint.pprint_struct), GarishPrint.GarishIO{Base.GenericIOBuffer{Array{UInt8, 1}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint_struct), GarishPrint.GarishIO{Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint_struct), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.GenericIOBuffer{Array{UInt8, 1}}}}, Base.Multimedia.MIME{Symbol("text/plain")}, Int})
    precompile(Tuple{typeof(GarishPrint.pprint_struct), Int})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{Base.GenericIOBuffer{Array{UInt8, 1}}}, Symbol, Type})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}}, Symbol, Type})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{Base.IOContext{Base.TTY}}, Symbol, Type})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{Base.TTY}, Symbol, Type})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.GenericIOBuffer{Array{UInt8, 1}}}}, Symbol, Type})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.IOContext{Base.TTY}}}, Symbol, Type})
    precompile(Tuple{typeof(GarishPrint.print_token), typeof(Base.print), GarishPrint.GarishIO{GarishPrint.GarishIO{Base.TTY}}, Symbol, Type})
end

_precompile_()