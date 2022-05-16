defmodule Atommix.Amis.OTP do
  @doc """
    OTP Register
  """

  def memory_structure() do
    structure = %{
      x00: [:OSC3, :OSC2, :OSC1, :OSC0, :IREF3, :IREF2, :IREF1, :IREF0],
      x01: [:enableLIN, :TSD2, :TSD1, :TSD0, :BG3, :BG2, :BG1, :BG0],
      x02: [:AbsThr3, :AbsThr2, :AbsThr1, :AbsThr0, :PA3, :PA2, :PA1, :PA0],
      x03: [:Irun3, :Irun2, :Irun1, :Irun0, :Ihold3, :Ihold2, :Ihold1, :Ihold0],
      x04: [:Vmax3, :Vmax2, :Vmax1, :Vmax0, :Vmin3, :Vmin2, :Vmin1, :Vmin0],
      x05: [:SecPos10, :SecPos9, :SecPos8, :Shaft, :Acc3, :Acc2, :Acc1, :Acc0],
      x06: [:SecPos7, :SecPos6, :SecPos5, :SecPos4, :SecPos3, :SecPos2, :Failsafe, :SleepEn],
      x07: [:DelThr3, :DelThr2, :DelThr1, :DelThr0, :StepMode1, :StepMode0, :LOCKBT, :LOCKBG]
    }

    structure
  end
end
