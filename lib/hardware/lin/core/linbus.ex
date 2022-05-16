defmodule Atomix.Linbus do
  @moduledoc """
  Implements the Local Interconnect Network (LIN) Bus

  The Local Interconnect Network (LIN) is a low-cost embedded networking standard for connecting intelligent devices. LIN is most popular in the automotive industry.

  ## Overview of LIN

  The Local Interconnect Network (LIN) bus was developed to create a standard for low-cost, low-end multiplexed communication in automotive networks. Though the Controller Area Network (CAN) bus addresses the need for high-bandwidth, advanced error-handling networks, the hardware and software costs of CAN implementation have become prohibitive for lower performance devices such as power window and seat controllers. LIN provides cost-efficient communication in applications where the bandwidth and versatility of CAN are not required. You can implement LIN relatively inexpensively using the standard serial universal asynchronous receiver/transmitter (UART) embedded into most modern low-cost 8-bit microcontrollers.

  Modern automotive networks use a combination of LIN for low-cost applications primarily in body electronics, CAN for mainstream powertrain and body communications, and the emerging FlexRay bus for high-speed synchronized data communications in advanced systems such as active suspension.

  The LIN bus uses a master/slave approach that comprises a LIN master and one or more LIN slaves.

  Features:

  ** LIN 1.3
  ** LIN 2.0
  Enhanced Checksum
  Off-the-shelf slave node concept
  NCF Format
  Diagnostic and slave node Configuration
  Byte Arrays

  """
  # https://www.ni.com/en-us/innovations/white-papers/09/introduction-to-the-local-interconnect-network--lin--bus.html?cid=Paid_Search-7013q000001Ugs4AAC-Consideration-GoogleSearch_126636340037&gclid=Cj0KCQjwvLOTBhCJARIsACVldV115PEpnWzz_ukRJDgnT9J7bhHTG2fEoaVOe6SlOX6cIh8SkHgW570aAjIKEALw_wcB
end
