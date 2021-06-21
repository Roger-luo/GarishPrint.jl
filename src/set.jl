function pprint(io::GarishIO, ::MIME"text/plain", s::Set)
    if isempty(s)
        if get(io, :typeinfo, Any) == typeof(s)
            printstyled(io, "Set"; color=io.color.type)
        else
            printstyled(io, typeof(s); color=io.color.type)
            print(io, "()")
        end
    else
        printstyled(io, "Set"; color=io.color.type)
        print(io, "(")
        pprint_list_like(io, s)
        print(io, ")")
    end
end
