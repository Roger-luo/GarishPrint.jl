using Test
using UUIDs
using Preferences
set_preferences!(
    UUID("b0ab02a7-8576-43f7-aa76-eaa7c3897c54"),
    "color"=>Dict("fieldname"=>"blue"),
    force=true,
)

using GarishPrint
@test GarishPrint.ColorPreference().fieldname === :blue
