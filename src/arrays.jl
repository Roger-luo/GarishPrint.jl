function pprint(io::GarishIO, ::MIME"text/plain", X::AbstractArray)
    ndims(X) == 0 && return pprint_zero_dim(io, X)

    if ndims(X) == 1
        # io.compact && return pprint_list_like(io, X)
        pprint_list_like(io, X)
        return
    end
    # fallback to compact show for high dimensional arrays
    # since we cannot control the indent in multi-line printing
    # not implemented with pprint interface
    return show(io, X)
end

# NOTE: modified based on base/arrayshow.jl:show_zero_dim
function pprint_zero_dim(io::GarishIO, X::AbstractArray{T, 0}) where T
    if isassigned(X)
        print(io, "fill(")
        pprint(io, X[])
    else
        print_token(io, :type, "Array{", T, ", 0}(")
        print_undef(io)
    end
    print(io, ")")
end

# NOTE: modified based on base/arrayshow.jl:show_vector
function pprint_list_like(io::GarishIO, list, opn='[', cls=']'; compact::Bool=io.compact)
    prefix, implicit = typeinfo_prefix(io.bland_io, list)
    io.state.noindent_in_first_line || print_indent(io)
    print_token(io, :type, prefix)

    # directly or indirectly, the context now knows about eltype(v)
    if !implicit
        io = GarishIO(IOContext(io.bland_io, :typeinfo => eltype(list)), io)
    end
    limited = get(io, :limit, false)

    if limited && length(list) > 20
        axs1 = Base.axes1(list)
        f, l = first(axs1), last(axs1)
        pprint_delim_list(io, list, opn, ",", "", false, compact, f, f+9)
        print(io, "  …  ")
        pprint_delim_list(io, list, "", ",", cls, false, compact, l-9, l)
    else
        pprint_delim_list(io, list, opn, ",", cls, false, compact)
    end
end

# NOTE: copied from base/show.jl:show_delim_array to use pprint for elements
function pprint_delim_list(io::GarishIO, itr, op, delim, cl, delim_one, compact, i1=1, n=typemax(Int))
    print(io.bland_io, op)
    compact || println(io)

    within_nextlevel(io) do
        if !Base.show_circular(io, itr)
            recur_io = IOContext(io.bland_io, :SHOWN_SET => itr)
            y = iterate(itr)
            first = true
            i0 = i1-1
            while i1 > 1 && y !== nothing
                y = iterate(itr, y[2])
                i1 -= 1
            end
            if y !== nothing
                typeinfo = get(io.bland_io, :typeinfo, Any)
                while true
                    x = y[1]
                    y = iterate(itr, y[2])
                    io_typeinfo = itr isa typeinfo <: Tuple ? fieldtype(typeinfo, i1+i0) : typeinfo
                    bland_io = IOContext(recur_io, :typeinfo => io_typeinfo)
                    nested_io = GarishIO(bland_io, io)

                    compact || print_indent(io)
                    pprint(nested_io, x)

                    i1 += 1
                    if y === nothing || i1 > n
                        if delim_one && first
                            print(io.bland_io, delim)
                            compact || println(io.bland_io)
                        end
                        break
                    end
                    first = false

                    print(io.bland_io, delim)
                    print(io.bland_io, ' ')
                    compact || println(io.bland_io)
                end
            end
        end

        if !compact
            print(io.bland_io, delim)
            print(io.bland_io, ' ')
            println(io.bland_io)
        end
    end
    compact || print_indent(io)
    print(io.bland_io, cl)
end


# NOTE: copied from base/arrayshow.jl:typeinfo_prefix(io::IO, X) for compatiblity
function typeinfo_prefix(io::IO, X)
    typeinfo = get(io, :typeinfo, Any)::Type

    if !(X isa typeinfo)
        typeinfo = Any
    end

    # what the context already knows about the eltype of X:
    eltype_ctx = Base.typeinfo_eltype(typeinfo)
    eltype_X = eltype(X)

    if X isa AbstractDict
        if eltype_X == eltype_ctx
            sprint(Base.show_type_name, typeof(X).name), false
        elseif !isempty(X) && typeinfo_implicit(keytype(X)) && typeinfo_implicit(valtype(X))
            sprint(Base.show_type_name, typeof(X).name), true
        else
            string(typeof(X)), false
        end
    else
        # Types hard-coded here are those which are created by default for a given syntax
        if eltype_X == eltype_ctx
            "", false
        elseif !isempty(X) && typeinfo_implicit(eltype_X)
            "", true
        elseif Base.print_without_params(eltype_X)
            sprint(Base.show_type_name, Base.unwrap_unionall(eltype_X).name), false # Print "Array" rather than "Array{T,N}"
        else
            string(eltype_X), false
        end
    end
end

# NOTE: copied from base/arrayshow.jl:typeinfo_implicit(@nospecialize(T)) for compatiblity
# types that can be parsed back accurately from their un-decorated representations
function typeinfo_implicit(@nospecialize(T))
    if T === Float64 || T === Int || T === Char || T === String || T === Symbol ||
        Base.issingletontype(T)
        return true
    end
    return isconcretetype(T) &&
        ((T <: Array && typeinfo_implicit(eltype(T))) ||
         ((T <: Tuple || T <: Pair) && all(typeinfo_implicit, fieldtypes(T))) ||
         (T <: AbstractDict && typeinfo_implicit(keytype(T)) && typeinfo_implicit(valtype(T))))
end