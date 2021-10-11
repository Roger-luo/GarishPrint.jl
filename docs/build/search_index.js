var documenterSearchIndex = {"docs":
[{"location":"ref/","page":"References","title":"References","text":"CurrentModule = GarishPrint","category":"page"},{"location":"ref/#Reference","page":"References","title":"Reference","text":"","category":"section"},{"location":"ref/","page":"References","title":"References","text":"Modules = [GarishPrint]","category":"page"},{"location":"ref/#GarishPrint.ColorPreference","page":"References","title":"GarishPrint.ColorPreference","text":"ColorPreference\n\nThe color preference type.\n\n\n\n\n\n","category":"type"},{"location":"ref/#GarishPrint.ColorPreference-Tuple{}","page":"References","title":"GarishPrint.ColorPreference","text":"ColorPreference(;kw...)\n\nSee pprint for available keyword configurations.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.GarishIO","page":"References","title":"GarishPrint.GarishIO","text":"GarishIO{IO_t <: IO} <: IO\n\nGarishIO contains the pretty printing preference and states.\n\nMembers\n\nbland_io::IO_t: the original io.\nindent::Int: indentation size.\ncompact::Bool: whether the printing should be compact.\nwidth::Int: the terminal width.\nshow_indent: print the indentation hint or not.\ncolor: color preference, either ColorPreference or nothing for no color.\nstate: the state of the printer, see PrintState.\n\n\n\n\n\n","category":"type"},{"location":"ref/#GarishPrint.GarishIO-Tuple{IO, GarishPrint.GarishIO}","page":"References","title":"GarishPrint.GarishIO","text":"GarishIO(io::IO, garish_io::GarishIO; kw...)\n\nCreate a new similar GarishIO with new bland IO object io based on an existing garish io preference. The preference can be overloaded by kw. See pprint for the available keyword arguments.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.GarishIO-Tuple{IO}","page":"References","title":"GarishPrint.GarishIO","text":"GarishIO(io::IO; kw...)\n\nSee pprint for available keywords.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.PrintType","page":"References","title":"GarishPrint.PrintType","text":"@enum PrintType\n\nPrintType to tell lower level printing some useful context. Currently only supports Unknown and StructField.\n\n\n\n\n\n","category":"type"},{"location":"ref/#GarishPrint.default_colors_256-Tuple{}","page":"References","title":"GarishPrint.default_colors_256","text":"default_colors_256()\n\nThe default color 256 theme.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.default_colors_ansi-Tuple{}","page":"References","title":"GarishPrint.default_colors_ansi","text":"default_colors_ansi()\n\nThe default ANSI color theme.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.pprint-Tuple{IO, MIME, Any}","page":"References","title":"GarishPrint.pprint","text":"pprint(io::IO, mime::MIME, x; kw...)\n\nPretty print an object x with given MIME type.\n\nwarning: Warning\ncurrently only supports MIME\"text/plain\", the implementation of MIME\"text/html\" is coming soon. Please also feel free to file an issue if you have a desired format wants to support.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.pprint-Tuple{IO, Vararg{Any, N} where N}","page":"References","title":"GarishPrint.pprint","text":"pprint([io::IO=stdout, ]xs...; kw...)\n\nPretty print given objects xs to io, default io is stdout.\n\nKeyword Arguments\n\nindent::Int: indent size, default is 2.\ncompact::Bool: whether print withint one line, default is get(io, :compact, false).\nwidth::Int: the width hint of printed string, note this is not stricted obeyed,\n\ndefault is displaysize(io)[2].\n\nshow_indent::Bool: whether print indentation hint, default is true.\ncolor::Bool: whether print with color, default is true.\n\nColor Preference\n\ncolor preference is available as keyword arguments to override the default color scheme. These arguments may take any of the values :normal, :default, :bold, :black, :blink, :blue, :cyan, :green, :hidden, :light_black, :light_blue, :light_cyan, :light_green, :light_magenta, :light_red, :light_yellow, :magenta, :nothing, :red, :reverse, :underline, :white, or :yellow or an integer between 0 and 255 inclusive. Note that not all terminals support 256 colors.\n\nThe default color scheme can be checked via GarishPrint.default_colors_256() for 256 color, and GarishPrint.default_colors_ansi() for ANSI color. The 256 color will be used when the terminal is detected to support 256 color.\n\nfieldname: field name of a struct.\ntype: the color of a type.\noperator: the color of an operator, e.g +, =>.\nliteral: the color of literals.\nconstant: the color of constants, e.g π.\nnumber: the color of numbers, e.g 1.2, 1.\nstring: the color of string.\ncomment: comments, e.g # some comments\nundef: the const binding to UndefInitializer\nlinenumber: line numbers.\n\nNotes\n\nThe color print and compact print can also be turned on/off by setting IOContext, e.g IOContext(io, :color=>false) will print without color, and IOContext(io, :compact=>true) will print within one line. This is also what the standard Julia IO objects follows in printing by default.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.pprint_list_like","page":"References","title":"GarishPrint.pprint_list_like","text":"pprint_list_like(io::GarishIO, list, opn='[', cls=']'; compact::Bool=io.compact)\n\nPrint a list-like object list. A list-like object should support the iterable interface such as Base.iterate and Base.length. This is modified based on base/arrayshow.jl:show_vector.\n\nArguments\n\nio::GarishIO: the GarishIO object one wants to print to.\nlist: the list-like object.\nopn: the openning marker, default is [.\ncls: the closing marker, default is ].\n\nKeyword Arguments\n\ncompact::Bool: print the list within one line or not.\n\n\n\n\n\n","category":"function"},{"location":"ref/#GarishPrint.pprint_struct-Tuple{GarishPrint.GarishIO, MIME{Symbol(\"text/plain\")}, Any}","page":"References","title":"GarishPrint.pprint_struct","text":"pprint_struct(io::GarishIO, ::MIME, x)\n\nPrint x as a struct type.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.print_indent-Tuple{GarishPrint.GarishIO}","page":"References","title":"GarishPrint.print_indent","text":"print_indent(io::GarishIO)\n\nPrint an indentation. This should be only used under MIME\"text/plain\" or equivalent.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.print_operator-Tuple{GarishPrint.GarishIO, Any}","page":"References","title":"GarishPrint.print_operator","text":"print_operator(io::GarishIO, op)\n\nPrint an operator, such as =, +, => etc. This should be only used under MIME\"text/plain\" or equivalent.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.print_token-Tuple{Any, GarishPrint.GarishIO, Symbol, Vararg{Any, N} where N}","page":"References","title":"GarishPrint.print_token","text":"print_token(f, io::GarishIO, type::Symbol, xs...)\n\nPrint xs to a GarishIO as given token type using f(io, xs...)\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.print_token-Tuple{GarishPrint.GarishIO, Symbol, Vararg{Any, N} where N}","page":"References","title":"GarishPrint.print_token","text":"print_token(io::GarishIO, type::Symbol, xs...)\n\nPrint xs to a GarishIO as given token type. The token type should match the field name of ColorPreference.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.supports_color256-Tuple{}","page":"References","title":"GarishPrint.supports_color256","text":"supports_color256()\n\nCheck if the terminal supports color 256.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.tty_has_color-Tuple{}","page":"References","title":"GarishPrint.tty_has_color","text":"tty_has_color()\n\nCheck if TTY supports color. This is mainly for lower Julia version like 1.0.\n\n\n\n\n\n","category":"method"},{"location":"ref/#GarishPrint.within_nextlevel-Tuple{Any, GarishPrint.GarishIO}","page":"References","title":"GarishPrint.within_nextlevel","text":"within_nextlevel(f, io::GarishIO)\n\nRun f() within the next level of indentation where f is a function that print into io.\n\n\n\n\n\n","category":"method"},{"location":"#GarishPrint","page":"Home","title":"GarishPrint","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: CI) (Image: codecov)","category":"page"},{"location":"","page":"Home","title":"Home","text":"An opinioned pretty printing package for Julia objects.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"<p>\nGarishPrint is a &nbsp;\n    <a href=\"https://julialang.org\">\n        <img src=\"https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia.ico\" width=\"16em\">\n        Julia Language\n    </a>\n    &nbsp; package. To install GarishPrint,\n    please <a href=\"https://docs.julialang.org/en/v1/manual/getting-started/\">open\n    Julia's interactive session (known as REPL)</a> and press <kbd>]</kbd> key in the REPL to use the package mode, then type the following command\n</p>","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add GarishPrint","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"there is only one function exported that is pprint,","category":"page"},{"location":"","page":"Home","title":"Home","text":"pprint","category":"page"},{"location":"#GarishPrint.pprint","page":"Home","title":"GarishPrint.pprint","text":"pprint([io::IO=stdout, ]xs...; kw...)\n\nPretty print given objects xs to io, default io is stdout.\n\nKeyword Arguments\n\nindent::Int: indent size, default is 2.\ncompact::Bool: whether print withint one line, default is get(io, :compact, false).\nwidth::Int: the width hint of printed string, note this is not stricted obeyed,\n\ndefault is displaysize(io)[2].\n\nshow_indent::Bool: whether print indentation hint, default is true.\ncolor::Bool: whether print with color, default is true.\n\nColor Preference\n\ncolor preference is available as keyword arguments to override the default color scheme. These arguments may take any of the values :normal, :default, :bold, :black, :blink, :blue, :cyan, :green, :hidden, :light_black, :light_blue, :light_cyan, :light_green, :light_magenta, :light_red, :light_yellow, :magenta, :nothing, :red, :reverse, :underline, :white, or :yellow or an integer between 0 and 255 inclusive. Note that not all terminals support 256 colors.\n\nThe default color scheme can be checked via GarishPrint.default_colors_256() for 256 color, and GarishPrint.default_colors_ansi() for ANSI color. The 256 color will be used when the terminal is detected to support 256 color.\n\nfieldname: field name of a struct.\ntype: the color of a type.\noperator: the color of an operator, e.g +, =>.\nliteral: the color of literals.\nconstant: the color of constants, e.g π.\nnumber: the color of numbers, e.g 1.2, 1.\nstring: the color of string.\ncomment: comments, e.g # some comments\nundef: the const binding to UndefInitializer\nlinenumber: line numbers.\n\nNotes\n\nThe color print and compact print can also be turned on/off by setting IOContext, e.g IOContext(io, :color=>false) will print without color, and IOContext(io, :compact=>true) will print within one line. This is also what the standard Julia IO objects follows in printing by default.\n\n\n\n\n\npprint(io::IO, mime::MIME, x; kw...)\n\nPretty print an object x with given MIME type.\n\nwarning: Warning\ncurrently only supports MIME\"text/plain\", the implementation of MIME\"text/html\" is coming soon. Please also feel free to file an issue if you have a desired format wants to support.\n\n\n\n\n\n","category":"function"},{"location":"","page":"Home","title":"Home","text":"here is a quick example","category":"page"},{"location":"","page":"Home","title":"Home","text":"using GarishPrint\n\nstruct ABC{T1, T2, T3}\n    hee::T1\n    haa::T2\n    hoo::T3\nend\n\nstruct Example{T1, T2}\n    field_a::T1\n    field_b::T2\n    abc::ABC\nend\n\nx = Example(\n    Dict(\n        \"a\"=>Example(\n            [1, 2, 3],\n            2.0,\n            ABC(1, 2.0im, 3.12f0),\n        ),\n        \"str\" => Set([1, 2, 3]),\n    ),\n    undef,\n    ABC(nothing, 1.2+2.1im, π),\n)\n\npprint(x)","category":"page"},{"location":"","page":"Home","title":"Home","text":"it will print the following","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: readme-example)","category":"page"},{"location":"#License","page":"Home","title":"License","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"MIT License","category":"page"}]
}