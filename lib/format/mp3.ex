defmodule Atomix.Format.MP3 do
  import NimbleParsec
  require Logger
  alias Atomix.Format.ID3

  sync_word =
    string(<<0x0F, 0x0F, 0x0F>>)
    |> tag(:sync)

  version =
    empty()
    |> tag(:version)

  header =
    sync_word
    |> concat(version)
    |> tag(:header)

  data =
    string("data")
    |> tag(:data)

  block =
    header
    |> concat(data)
    |> tag(:block)

  id3tag =
    empty()
    |> tag(:id3tag)

  mp3 =
    repeat(
      id3tag
      |> concat(header)
      |> concat(block)
    )
    |> tag(:mp3)

  defparsec(:mp3, mp3)

  def open(path) do
    data = File.read!(path)
    {:ok, [mp3: _], result, %{}, {1, 0}, 0} = mp3(data)
    result
  end
end
