function pprint(io::GarishIO, ::MIME"text/plain", d::AbstractDict)
    # heurostics to print Dict in compact form
    if length(d) < 20 && !max_indent_reached(io, length(string(d)))
        pprint_list_like(io, d, "(", ")"; compact=true)
    else
        pprint_list_like(io, d, "(", ")")
    end
end
