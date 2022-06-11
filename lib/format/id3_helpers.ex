defmodule Atomix.Format.ID3.Helpers do
  import NimbleParsec
  import Logger

  integer(5)
  |> tag(:header)

  def header(<<"ID3", 49, 44, 33, yy, yy, xx, zz, zz, zz, zz>>)
      when yy < 0xFF and
             zz < 0x80 do
    :ok
  end

  def header(other) do
    Logger.info("Uhandled ID3 Header")
    Logger.info(inspect(other))
  end
end
