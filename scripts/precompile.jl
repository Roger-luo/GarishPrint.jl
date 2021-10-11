using GarishPrint
using SnoopCompile

### Log the compiles
# This only needs to be run once (to generate "/tmp/colortypes_compiles.log")

SnoopCompile.@snoopc ["--project=$(pkgdir(GarishPrint))"] "/tmp/garish_print_compiles.log" begin
    using GarishPrint, Pkg
    include(pkgdir(GarishPrint, "test", "runtests.jl"))
end

### Parse the compiles and generate precompilation scripts
# This can be run repeatedly to tweak the scripts

data = SnoopCompile.read("/tmp/garish_print_compiles.log")

pc = SnoopCompile.parcel(reverse!(data[2]))
SnoopCompile.write("/tmp/precompile", pc)