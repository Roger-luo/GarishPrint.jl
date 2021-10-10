function pprint(io::GarishIO, mime::MIME"text/plain", d::AbstractDict)
    # use default printing if it's the root
    io.state.level == 0 && return show(io, mime, d)
    # heurostics to print Dict in compact form
    if length(d) < 20 && !max_indent_reached(io, length(string(d)))
        pprint_list_like(io, d, "(", ")"; compact=true)
    else
        pprint_list_like(io, d, "(", ")")
    end
end
