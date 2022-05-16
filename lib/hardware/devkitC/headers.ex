defmodule Atomix.Hardware.DevkitC.Headers do
  @csv_file_header1 "../../docsource/hardware/esp32/devkitC/HeaderJ1/HeaderJ1/table-1.csv"
  @csv_file_header2 "../../docsource/hardware/esp32/devkitC/HeaderJ2/HeaderJ2/table-1.csv"

  def headerJ1() do
    build_from_csv(@csv_file_header1)
  end

  def headerJ2() do
    source = build_from_csv(@csv_file_header2)
    pin = find_pin_by_id(source, :GPIO42)
    pin
  end

  def find_pin_by_id(header, pin_identifier) do
    # Find a line in header that contains the function named pin_identifier
    IO.inspect(header)
    # This is a list of maps, each which contain a :functions field, so let's
    # first filter out only the ones that have the given pin_identifier in the functions field
    found =
      Enum.filter(header, fn block ->
        Enum.any?(block.functions, fn x -> x == pin_identifier end)
      end)

    IO.inspect(found)
    0
  end

  def build_from_csv(csv) do
    lines =
      csv
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode!()

    [column_names] = Enum.take(lines, 1)
    IO.puts("column_names")
    IO.inspect(column_names)
    IO.puts("Trim")
    column_names = Enum.map(column_names, &String.trim/1)
    IO.inspect(column_names)

    data =
      Enum.map(Enum.drop(lines, 1), fn line ->
        Enum.map(line, &String.trim/1)
      end)

    IO.puts("Data")
    IO.inspect(data)

    mapped_data =
      Enum.map(data, fn [c1, c2, c3, c4, _c5] ->
        %{
          pin: String.to_integer(strip_apostrophes(c1)),
          name: strip_apostrophes(c2),
          type: strip_apostrophes(c3),
          functions: Enum.map(String.split(c4, ","), &string_to_function_name/1)
        }
      end)

    IO.puts("Mapped data")
    IO.inspect(mapped_data)
    mapped_data
  end

  defp strip_apostrophes(str) do
    Regex.replace(~r{'}, str, "")
  end

  defp string_to_function_name(str) do
    String.to_atom(String.trim(strip_apostrophes(str)))
  end
end
