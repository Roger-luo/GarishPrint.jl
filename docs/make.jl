using Documenter
using GarishPrint
using DocThemeIndigo

indigo = DocThemeIndigo.install(GarishPrint)

makedocs(;
    modules = [GarishPrint],
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical="https://Roger-luo.github.io/GarishPrint.jl",
        assets=String[indigo],
    ),
    pages = [
        "Home" => "index.md",
        "References" => "ref.md",
    ],
    repo = "https://github.com/Roger-luo/GarishPrint.jl",
    sitename = "GarishPrint.jl",
)

deploydocs(; repo = "github.com/Roger-luo/GarishPrint.jl")
