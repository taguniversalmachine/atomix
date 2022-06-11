defmodule Atomix.Hardware.RockerSwitch do
  alias Atomix.Reader, as: R
  require Logger

  def init(file) do
    pins = R.get(:rocker_switch)
    {:ok, supercollider} = File.read(file)
    {:ok, pins} = R.get(:rocker_switch)
    Logger.info("Starting Rocker switch with #{inspect(supercollider)}")
  end
end
