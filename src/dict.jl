function pprint(io::GarishIO, ::MIME"text/plain", d::AbstractDict)
    # NOTE: unlike Vector, we only do compact print when it's turned on
    pprint_list_like(io, d, "(", ")")
end
