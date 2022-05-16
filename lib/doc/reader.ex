defmodule Atomix.Reader do
  require Logger
  require CSV

  def get(:esp32) do
    path =
      "/Users/eflores/src/atomix/lib/docsource/hardware/esp32/4.9 Peripheral Signal List/analyzeDocResponse.json"

    json_file = File.read!(path)
    doc = Jason.decode!(json_file)
    IO.inspect(doc)
    blocks = doc["Blocks"]
    IO.inspect(blocks)
    %{doc: doc, blocks: blocks}
  end

  def get(:peripherals49) do
    path = "/Users/eflores/src/atomix/lib/docsource/hardware/esp32/4.9 Peripheral Signal List"
    page_paths = Enum.map(1..5, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    csv_files = Enum.map(page_paths, fn path -> File.stream!(path) end)
    decoded_pages = Enum.map(csv_files, fn csv_file -> CSV.decode(csv_file) end)
    decoded_pages_list = List.flatten(Enum.map(decoded_pages, fn page -> Enum.to_list(page) end))

    labeled_signals =
      Enum.map(decoded_pages_list, fn {:ok,
                                       [
                                         str_pin,
                                         str_signal_in,
                                         str_signal_out,
                                         str_direct_io,
                                         _other
                                       ]} ->
        %{
          pin: String.to_integer(strip_apostrophes(str_pin)),
          signal_in: signal_str_to_atom(str_signal_in),
          signal_out: signal_str_to_atom(str_signal_out),
          direct_io: str_direct_io == "YES"
        }
      end)

    labeled_signals
  end

  def get(:mux_pad_list) do
    path = "/Users/eflores/src/atomix/lib/docsource/hardware/esp32/4.10 IO_MUX Pad List"

    [Path.join(path, "/p0/table-1.csv")]
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.map(fn {:ok, [str_GPIO, str_Pad_Name, str_Function_0, str_Function_1, str_Function_2, str_Function_3, str_Function_4, str_Function_5, str_Reset, str_Notes, _other ]} ->
      %{
        GPIO: String.to_integer(oh_to_zero(strip_apostrophes(str_GPIO))),
        Pad_Name: signal_str_to_atom(str_Pad_Name),
        function_0: signal_str_to_atom(str_Function_0),
        function_1: signal_str_to_atom(str_Function_1),
        function_2: signal_str_to_atom(str_Function_2),
        function_3: signal_str_to_atom(str_Function_3),
        function_4: signal_str_to_atom(str_Function_4),
        function_5: signal_str_to_atom(str_Function_5),
        reset: String.to_integer(oh_to_zero(strip_apostrophes(str_Reset))),
        notes: signal_str_to_atom(str_Notes)
      }
    end)
  end

  def confidence(doc) do
    confidence_vals = Enum.map(doc, fn x -> x["Confidence"] end)
    confidence_vals = Enum.reject(confidence_vals, fn d -> d == nil end)
    confidence_sum = Enum.reduce(confidence_vals, 0, &Kernel.+/2)
    confidence_sum
  end

  def read(blocks) do
    Logger.info("Reading blocks")
    IO.inspect(blocks)
    %{}
  end

  defp strip_apostrophes(str) do
    Regex.replace(~r{[' ]}, str, "")
  end

  defp oh_to_zero("O"), do: "0"
  defp oh_to_zero(other), do: other

  defp signal_to_atom("-") do
    :na
  end

  defp signal_to_atom(other) do
    String.to_atom(other)
  end

  defp signal_str_to_atom(signal_str) do
    signal_to_atom(strip_apostrophes(signal_str))
  end
end
