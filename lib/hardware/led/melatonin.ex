defmodule Atomix.LED.Melatonin do
  def melatonin() do
    [
      %{
        :"Light source" => :"Daylight (CIE D65)",
        :"25% suppression" => "80",
        :"50% suppression" => "270"
      },
      %{
        :"Light source" => :"2856 K incandescent A-lamp",
        :"25% suppression" => "147",
        :"50% suppression" => "511"
      },
      %{
        :"Light source" => :"2700 K CFL (Greenlite 15WELS-M)",
        :"25% suppression" => "207",
        :"50% suppression" => "722"
      },
      %{
        :"Light source" => :"3350 K linear fluorescent (GE F32T8 SP35)",
        :"25% suppression" => "144",
        :"50% suppression" => "501"
      },
      %{
        :"Light source" => :"4100 K linear fluorescent (GE F32T8 SP41)",
        :"25% suppression" => "214",
        :"50% suppression" => "708"
      },
      %{
        :"Light source" => :"5200 K LED phosphor white (Luxeon Star)",
        :"25% suppression" => "154",
        :"50% suppression" => "515"
      },
      %{
        :"Light source" => :"8000 K Lumilux Skywhite fluorescent (OSI)",
        :"25% suppression" => "79",
        :"50% suppression" => "266"
      },
      %{
        :"Light source" => "Blue LED (Luxeon Rebel, A = 470 nm) peak",
        :"25% suppression" => "9",
        :"50% suppression" => "30"
      }
    ]
  end
end
