defmodule Atomix.Lin.Master do
  alias Atomix.Lin.Frame
  alias Atomix.Lin.Slave
  use GenServer

  def init(state) do
    slave_task = Task.async(fn -> slave_work() end)
    state = %{sinternal_slave: slave_task}
    {:ok, state}
  end

  def slave_work() do
    :ok
  end

  def poll(slaves) do
    Enum.map(slaves, &poll_slave/1)
  end

  defp poll_slave(slave) do
    header(slave)
  end

  defp header(slave) do
    Frame.header(slave)
  end

  defp transmit() do

  end
end
