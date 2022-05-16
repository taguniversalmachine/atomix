defmodule Atomix.Lin.Frame do
  @moduledoc """
    LIN Frame Format

  The LIN bus is a polled bus with a single master device and one or more slave devices. The master device contains both a master task and a slave task. Each slave device contains only a slave task. Communication over the LIN bus is controlled entirely by the master task in the master device. The basic unit of transfer on the LIN bus is the frame, which is divided into a header and a response. The header is always transmitted by the master node and consists of three distinct fields: the break, synchronization (sync), and identifier (ID). The response, which is transmitted by a slave task and can reside in either the master node or a slave node, consists of a data payload and a checksum.

  Normally, the master task polls each slave task in a loop by transmitting a header, which consists of a break-sync-ID sequence. Prior to starting the LIN, each slave task is configured to either publish data to the bus or subscribe to data in response to each received header ID. Upon receiving the header, each slave task verifies ID parity and then checks the ID to determine whether it needs to publish or subscribe. If the slave task needs to publish a response, it transmits one to eight data bytes to the bus followed by a checksum byte. If the slave task needs to subscribe, it reads the data payload and checksum byte from the bus and takes appropriate internal action.
  """
  @moduledoc since: "0.1.0"

  defstruct do
    [:break, :sync, :lin_id]
  end

  @doc """
     Valid IDs for a frame fall into these categories: signal, diagnostic, user_extensions, enhancements.
  """
  def ids do
    signal = Enum.map([0..59], fn x -> <<x::8>> end)
    diagnostic = Enum.map([60, 61], fn x -> <<x::8>> end)
    user_extensions = Enum.map([62], fn x -> <<x::8>> end)
    enhancements = Enum.map([63], fn x -> <<x::8>> end)

    %{
      signal: signal,
      diagnostic: diagnostic,
      user_extensions: user_extensions,
      enhancements: enhancements
    }
  end

  def header(id) do
    # break-sync-id sequence
    id = id
    <<break()>>
  end

  @doc """
    Every LIN frame begins with the break, which comprises 13 dominant bits (nominal) followed by a break delimiter of one bit (nominal) recessive. This serves as a start-of-frame notice to all nodes on the bus.
  """
  def break() do
    <<0::13, 1::1>>
  end

  @doc """
  The sync field is the second field transmitted by the master task in the header. Sync is defined as the character x55. The sync field allows slave devices that perform automatic baud rate detection to measure the period of the baud rate and adjust their internal baud rates to synchronize with the bus.
  """
  def sync() do
    0x55
  end

  @doc """
  The ID field is the final field transmitted by the master task in the header. This field provides identification for each message on the network and ultimately determines which nodes in the network receive or respond to each transmission. All slave tasks continually listen for ID fields, verify their parities, and determine if they are publishers or subscribers for this particular identifier. The LIN bus provides a total of 64 IDs. IDs 0 to 59 are used for signal-carrying (data) frames, 60 and 61 are used to carry diagnostic data, 62 is reserved for user-defined extensions, and 63 is reserved for future protocol enhancements. The ID is transmitted over the bus as one protected ID byte, with the lower six bits containing the raw ID and the upper two bits containing the parity.
  """
  def lin_id() do
    0
  end

  @doc """
    Protected ID - the lower six bits containing the raw ID and the upper two bits containing the parity
  """
  def protected_id(lin_id) do
    lower_bits = <<0, 0, 0, 0, 0, 0>>
    upper_two = <<0, 0>>
    parity = parity(lower_bits)
  end

  def parity(bits) do
    p1 = [1, 3, 4, 5]
    p0 = [0, 1, 2, 4]
    0
  end
end
