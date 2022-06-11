defmodule AtomixTest do
  use ExUnit.Case
  doctest Atomix
  require Logger

  test "starts master task" do
    {:ok, master} = GenServer.start_link(Atomix.Lin.Master, %{})
    assert Process.alive?(master)
  end

  test "reads doc" do
    peripherals = Atomix.Reader.get(:peripherals_4_9)
    assert Enum.count(peripherals) == 199

    mux_pad_list = Atomix.Reader.get(:mux_pad_list_4_10)
    assert Enum.count(mux_pad_list) == 34

    rtc_mux_pin_list = Atomix.Reader.get(:rtc_mux_pin_list_4_11)
    assert Enum.count(rtc_mux_pin_list) == 18

    gpio_matrix_register_summary = Atomix.Reader.get(:gpio_matrix_summary_4_12_1)
    assert Enum.count(gpio_matrix_register_summary) == 42

    io_mux_register_summary_4_12_2 = Atomix.Reader.get(:io_mux_register_summary_4_12_2)
    assert Enum.count(io_mux_register_summary_4_12_2) == 37

    rtc_io_mux_register_summary_4_12_3 = Atomix.Reader.get(:rtc_io_mux_register_summary_4_12_3)
    assert Enum.count(rtc_io_mux_register_summary_4_12_3) == 35

    peripherals_1_3_5 = Atomix.Reader.get(:peripherals_1_3_5)
    assert Enum.count(peripherals_1_3_5) == 39
    assert Enum.at(peripherals_1_3_5, 0)[:Target] == "DPortRegister"
  end
end
