defmodule Atomix.Hardware.ESP32.EFuseController do
  alias Atomix.Reader, as: R

  def init() do
    spec = R.read(:efuse_controller_20)
    spec
  end
end
