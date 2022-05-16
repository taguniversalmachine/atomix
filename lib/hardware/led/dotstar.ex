defmodule Atomix.LED.DotStar do
  def rgb(r, g, b) do
    <<r::8, g::8, b::8>>
  end

  def set_color(led, color) do
    color
  end
end
