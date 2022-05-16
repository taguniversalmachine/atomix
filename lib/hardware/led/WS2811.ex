defmodule Atomix.LED.WS2811 do
  def packet(r, g, b) do
    <<r::8, g::8, b::8>>
  end
end
