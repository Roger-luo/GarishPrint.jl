module TestColors

using Test
using GarishPrint
using GarishPrint: ColorScheme, monokai_256
using Configurations
cs = monokai_256()
d = to_dict(cs)
@test from_dict(ColorScheme, d) == cs

end
