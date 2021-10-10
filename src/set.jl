function pprint(io::GarishIO, ::MIME"text/plain", s::Set)
    # use default printing if it's the root
    io.state.level == 0 && return show(io, mime, d)

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
        # io.compact && return pprint_list_like(io, X)
        # heurostics to print vector in compact form
        if length(s) < 20 && !max_indent_reached(io, length(string(s)))
            pprint_list_like(io, s; compact=true)
        else
            pprint_list_like(io, s)
        end
        print(io, ")")
    end
end
