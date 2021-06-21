function pprint(io::GarishIO, ::MIME"text/plain", d::AbstractDict)
    pprint_list_like(io, d, "(", ")")
end
