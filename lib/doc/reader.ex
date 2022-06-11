defmodule Atomix.Reader do
  require Logger
  import NimbleParsec
  alias Atomix.Invocation.Parser

  switch = "switch"
  pin = "pin"
  component_name = string("component")

  switch_pinout =
    string(switch)
    |> concat(component_name)
    |> concat(string("pin"))

  defparsec(:switch_pinout, switch_pinout)

  # Peripherasl 4 9
  pin_number = string("0")
  signal = string("SPICLK_in")
  signal2 = string("SPICLK_out")
  direct_io = string("YES")

  defparsec(
    :peripherals,
    ignore(string("#"))
    |> ignore(string(","))
    |> concat(pin_number)
    |> ignore(string(","))
    |> concat(signal)
    |> concat(direct_io)
  )

  def get(:peripherals_4_9) do
    # "'0 ","'SPICLK_in ","'SPICLK_out ","'YES ",
    path = Path.absname("lib/docsource/hardware/esp32/4.9 Peripheral Signal List")

    Enum.map(1..6, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.reject(fn {:ok, [a, _b, _c, _d, _e]} -> String.trim(strip_apostrophes(a)) == "" end)
    |> Enum.map(fn {:ok,
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
  end

  def get(:mux_pad_list_4_10) do
    path = Path.absname("lib/docsource/hardware/esp32/4.10 IO_MUX Pad List")

    [Path.join(path, "/p0/table-1.csv")]
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.map(fn {:ok,
                    [
                      str_GPIO,
                      str_Pad_Name,
                      str_Function_0,
                      str_Function_1,
                      str_Function_2,
                      str_Function_3,
                      str_Function_4,
                      str_Function_5,
                      str_Reset,
                      str_Notes,
                      _other
                    ]} ->
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
        notes: strip_apostrophes(str_Notes)
      }
    end)
  end

  def get(:rtc_mux_pin_list_4_11) do
    Path.absname("lib/docsource/hardware/esp32/4.11 RTC_MUX Pin List")
    |> Path.join("/p0/table-1.csv")
    |> File.stream!()
    |> CSV.decode()
    |> Enum.to_list()
    |> Enum.map(fn {:ok,
                    [
                      str_RTC_GPIO_Num,
                      str_GPIO_Num,
                      str_Pad_Name,
                      str_Analog_Function_0,
                      str_Analog_Function_1,
                      str_Analog_Function_2,
                      str_RTC_Function_0,
                      str_RTC_Function_1,
                      _other
                    ]} ->
      %{
        RTC_GPIO_Num: String.to_integer(oh_to_zero(strip_apostrophes(str_RTC_GPIO_Num))),
        GPIO_Num: String.to_integer(oh_to_zero(strip_apostrophes(str_GPIO_Num))),
        Pad_Name: signal_str_to_atom(str_Pad_Name),
        Analog_Function_0: signal_str_to_atom(str_Analog_Function_0),
        Analog_Function_1: signal_str_to_atom(str_Analog_Function_1),
        Analog_Function_2: signal_str_to_atom(str_Analog_Function_2),
        RTC_Function_0: signal_str_to_atom(str_RTC_Function_0),
        RTC_Function_1: signal_str_to_atom(str_RTC_Function_1)
      }
    end)
  end

  def get(:gpio_matrix_summary_4_12_1) do
    path = Path.absname("lib/docsource/hardware/esp32/4.12.1 GPIO Matrix Register Summary")

    Enum.map(0..1, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.reject(fn {:ok, [a, _b, _c, _d, _e]} -> String.trim(strip_apostrophes(a)) == "" end)
    |> Enum.map(fn {:ok,
                    [
                      str_Name,
                      str_Description,
                      str_Address,
                      str_Access,
                      _other
                    ]} ->
      %{
        Name: String.to_atom(strip_apostrophes(str_Name)),
        Description: strip_apostrophes(str_Description),
        Address: strip_apostrophes(str_Address),
        Access: string_to_access_atom(strip_apostrophes(str_Access))
      }
    end)
  end

  def get(:io_mux_register_summary_4_12_2) do
    path = Path.absname("lib/docsource/hardware/esp32/4.12.2 IO MUX Register Summary")

    Enum.map(0..1, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.map(fn {:ok,
                    [
                      str_Name,
                      str_Description,
                      str_Address,
                      str_Access,
                      _other
                    ]} ->
      %{
        Name: strip_apostrophes(str_Name),
        Description: strip_apostrophes(str_Description),
        Address: strip_apostrophes(str_Address),
        Access: string_to_access_atom(strip_apostrophes(str_Access))
      }
    end)
  end

  def get(:rtc_io_mux_register_summary_4_12_3) do
    path = Path.absname("lib/docsource/hardware/esp32/4.12.3 RTC IO MUX Register Summary")

    Enum.map(0..1, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.map(fn {:ok,
                    [
                      str_Name,
                      str_Description,
                      str_Address,
                      str_Access,
                      _other
                    ]} ->
      %{
        Name: strip_apostrophes(str_Name),
        Description: strip_apostrophes(str_Description),
        Address: strip_apostrophes(str_Address),
        Access: string_to_access_atom(strip_apostrophes(str_Access))
      }
    end)
  end

  def get(:peripherals_1_3_5) do
    path = Path.absname("lib/docsource/hardware/esp32/1.3.5 Peripherals")

    Enum.map(0..1, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.reject(fn {:ok, [_, _, _, _, strTarget, _, _]} ->
      strip_apostrophes(strTarget) == "Reserved"
    end)
    |> Enum.map(fn {:ok,
                    [
                      str_BusType,
                      str_LowAddress,
                      str_HighAddress,
                      str_Size,
                      str_Target,
                      str_Comment,
                      _other
                    ]} ->
      %{
        BusType: strip_apostrophes(str_BusType),
        LowAddress: strip_apostrophes(str_LowAddress),
        HighAddress: strip_apostrophes(str_HighAddress),
        Size: strip_apostrophes(str_Size),
        Target: fixTarget(strip_apostrophes(str_Target)),
        Comment: strip_apostrophes(str_Comment)
      }
    end)
  end

  def get(:efuse_controller_20) do
    path = Path.absname("lib/docsource/hardware/esp32/20 eFuse Controller/p0
")

    Enum.map(0..1, fn page -> Path.join(path, "/p#{page}/table-1.csv") end)
    |> Enum.map(fn path -> File.stream!(path) end)
    |> Enum.map(fn csv_file -> CSV.decode(csv_file) end)
    |> Enum.map(fn page -> Enum.to_list(page) end)
    |> List.flatten()
    |> Enum.reject(fn {:ok, [_, _, _, _, strTarget, _, _]} ->
      strip_apostrophes(strTarget) == "Reserved"
    end)
    |> Enum.map(fn {:ok,
                    [
                      str_efuse_wr_disable,
                      str_efuse_rd_disable,
                      str_lash_crypt_cnt,
                      str_WIFI_MAC_Address,
                      str_SPI_pad_config_hd,
                      str_XPD_SDIO_REG,
                      str_DIO_TIEH,
                      str_sdio_force,
                      str_BLK3_part_reserve,
                      str_SPI_pad_config_clk
                    ]} ->
      %{
        EfuseWriteDisable: strip_apostrophes(str_efuse_wr_disable),
        EfuseReadDisable: strip_apostrophes(str_efuse_rd_disable),
        LashCryptCount: strip_apostrophes(str_lash_crypt_cnt),
        WIFIMACAddress: strip_apostrophes(str_WIFI_MAC_Address),
        SPIPadConfigHD: strip_apostrophes(str_SPI_pad_config_hd),
        SPDSDIO: strip_apostrophes(str_XPD_SDIO_REG),
        XPD_SDIO_REG: strip_apostrophes(str_XPD_SDIO_REG),
        DIO_TIEH: strip_apostrophes(str_DIO_TIEH),
        SDIO_FORCE: strip_apostrophes(str_sdio_force),
        BLK3_Part_Reserve: strip_apostrophes(str_BLK3_part_reserve),
        SPI_pad_config_clk: strip_apostrophes(str_SPI_pad_config_clk)
      }
    end)
  end

  def get(part) do
    path = Path.absname("lib/docsource/hardware/#{part}/#{part}.definition")
    Parser.definition(File.read!(path))
  end

  defp fixTarget("10MUX"), do: "IOMUX"
  defp fixTarget(other), do: other

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

  # OCR misread
  defp oh_to_zero("O"), do: "0"
  defp oh_to_zero(other), do: other

  defp signal_to_atom("-") do
    :na
  end

  defp signal_to_atom(other) do
    String.to_atom(other)
  end

  defp string_to_access_atom("ro"), do: :RO
  defp string_to_access_atom("RO"), do: :RO
  defp string_to_access_atom("wo"), do: :WO
  defp string_to_access_atom("WO"), do: :WO
  defp string_to_access_atom("r/w"), do: :RW
  defp string_to_access_atom("R/W"), do: :RW

  defp signal_str_to_atom(signal_str) do
    signal_to_atom(strip_apostrophes(signal_str))
  end
end
