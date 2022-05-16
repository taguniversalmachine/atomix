defmodule Atomix.LED.Strip do
  defstruct [:length, :voltage, :power, :vcc, :gnd, :dat, :do, :di, :data_direction]

  def led_controllers() do
    [:WS2811, :WS2812, :WS2812B, :WS2813, :WS2815, :SK6812, :SK9822]
  end

  def specs_epistar() do
    [
      %{
        :LED => "2835",
        :"Chip Surface Area" => "9.8 mm2",
        :"Luminous Flux" => "22-24 lm",
        :"Power consumed" => "0.2 W"
      },
      %{
        :LED => "5054",
        :"Chip Surface Area" => "27 mm2",
        :"Luminous Flux" => "45-55 lm",
        :"Power consumed" => "0.5 W"
      },
      %{
        :LED => "5630",
        :"Chip Surface Area" => "16.8 mm2",
        :"Luminous Flux" => "50-60 lm",
        :"Power consumed" => "0.5 W"
      }
    ]
  end

  def lumens_per_foot_by_application() do
    [
      %{
        :"Accent/Mood lighting" => 150..350,
        :"Under cabinet lighting" => 175..525,
        :"Task lighting (close)" => 275..450,
        :"Task lighting (far)" => 350..700,
        :"Indirect lighting" => 375..575,
        :"Fluorescent tube replacement" => 500..950
      }
    ]
  end

  def melatonin_suppression() do
    %{}
  end
end
