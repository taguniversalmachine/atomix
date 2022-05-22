defmodule Atomix.Esp32.Core.GPIO.GPIO do
  alias Atomix.Reader
  alias Atomix.Esp32.Core.GPIO.Matrix

  @onload :init

  def init do
    :erlang.load_nif("./atomix_gpio.nif", 0)
    :ok
  end

  def get_by_name(name) do
    gpio_matrix_summary = Reader.get(:gpio_matrix_summary_4_12_1)
    Enum.find(gpio_matrix_summary, fn line -> line[:Name] == name end)
  end

  def route_pad_to_peripheral_signal(pad_number, peripheral_number) do
    # To read GPIO pad X into peripheral signal Y, follow the steps below:
    # 1. Configure the GPIO_FUNCy_IN_SEL_CFG register corresponding to peripheral signal Y in the GPIO Matrix:
    # Set the GPIO_FUNCy_IN_SEL field in this register, corresponding to the GPIO pad X to read from.
    # Clear all other fields corresponding to other GPIO pads.
    register = String.to_atom("GPIO_FUNC#{peripheral_number}_IN_SEL_CFG")
    field = String.to_atom("GPIO_FUNC#{peripheral_number}_IN_SEL")
    Matrix.clear_fields(register)
    Matrix.set_field(register, field)
  end

  def route_peripheral_signal_to_pad(signal_number, pad_number) do
  end
end
