function pprint(io::GarishIO, ::MIME"text/plain", s::Set)
    if isempty(s)
        if get(io, :typeinfo, Any) == typeof(s)
            print_token(io, :type, "Set")
        else
            print_token(io, :type, typeof(s))
            print(io, "()")
        end
    else
        print_token(io, :type, "Set")
        print(io, "(")
        pprint_list_like(io, s)
        print(io, ")")
    end
end
