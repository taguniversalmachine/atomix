defmodule Atomix.Format.MP3Helpers do
  import NimbleParsec

  def header do
    integer(4)
  end
end
