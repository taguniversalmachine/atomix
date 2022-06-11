defmodule Atomix.Format.ID3 do
  require Logger
  import NimbleParsec
  import Atomix.Format.ID3.Helpers

  header = string("0123456789")

  extended_header =
    string("extended headex`x`r")
    |> tag(:extended_header)

  data =
    string("data")
    |> tag(:data)

  frame =
    header
    |> concat(data)
    |> tag(:frame)

  frames =
    repeat(frame)
    |> tag(:frames)

  padding_material =
    string(" ")
    |> tag(:padding_material)

  padding =
    repeat(padding_material)
    |> tag(:padding)

  footer =
    string("3DI")
    |> tag(:footer)

  id3tag =
    header
    |> concat(
      optional(extended_header)
      |> concat(repeat(frames))
    )
    |> concat(padding)
    |> concat(footer)

  defparsec(:id3tag, id3tag)

  def open(file) do
    Logger.info("Opening file #{file}")
    #  {:ok, id3_file} = File.open(file)
    {:ok, id3_file} = File.read(file)
    Logger.info("Opened file #{inspect(id3_file)}")
    decode(id3_file)
  end

  def decode(data) do
    Logger.info("Detecting #{inspect(data)}")
    detected = detect(data)
    Logger.info("MP3 Detected #{inspect(detected)}")
    Logger.info("Extracting..")
    result = ID3.id3tag(data)
    IO.inspect(result)
    result
  end

  def format do
    %{:header => 10, :x_header => 10, :frames => [], :padding => []}
  end

  def header(content) do
    <<"ID3", 0x04, 0x00, unsynchronization, extended_header, experimantal, footer_present, 0::1,
      0::1, 0::1, 0::1>> = content

    # a- unsynchronization

    # b- extended header
    # c- experimental indicator
    # d- footer present
  end

  def detect(content) do
    content = <<"ID3", 0x04, 0x00>>
    true
  end

  def extract(content) do
    Logger.info("Extracting content #{inspect(content)}")

    content
  end

  def synchsafe(
        <<high::1, b15::1, b14::1, b13::1, b12::1, b11::1, b10::1, b9::1, b8::1, b7::1, b6::1,
          b5::1, b4::1, b3::1, b2::1, b1::1, b0::1>>
      ) do
    <<0::1, b15::1, b14::1, b13::1, b12::1, b11::1, b10::1, b9::1, b8::1, b7::1, b6::1, b5::1,
      b4::1, b3::1, b2::1, b1::1, b0::1>>
  end
end
