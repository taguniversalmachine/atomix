defmodule Atomix.Hardware.NIFGen do
  def generate() do
    header_file = EEx.compile_file("lib/docsource/hardware/esp32/nif/atomix_nif.h.eex")

    {header, _bindings} =
      Code.eval_quoted(header_file,
        assigns: [
          peripherals_4_9: Atomix.Reader.get(:peripherals_4_9),
          mux_pad_function_gpio: mux_pad_function_gpio()
        ]
      )

    c_file = EEx.compile_file("lib/docsource/hardware/esp32/nif/atomix_nif.c.eex")
    {c_program, _bindings} = Code.eval_quoted(c_file, assigns: [])
    {header, c_program}
  end

    def all_mux_pad_functions() do
    Atomix.Reader.get(:mux_pad_list_4_10)
    |> Enum.map(fn pad -> [pad.function_0, pad.function_1, pad.function_2, pad.function_3, pad.function_4, pad.function_5] end)
    |> List.flatten
    |> Enum.reject(fn fun -> fun == :na end)
  #  %{
  #    GPIO: String.to_integer(oh_to_zero(strip_apostrophes(str_GPIO))),
  #    Pad_Name: signal_str_to_atom(str_Pad_Name),
  #    function_0: signal_str_to_atom(str_Function_0),
  #    function_1: signal_str_to_atom(str_Function_1),
  #    function_2: signal_str_to_atom(str_Function_2),
  #    function_3: signal_str_to_atom(str_Function_3),
  #    function_4: signal_str_to_atom(str_Function_4),
  #    function_5: signal_str_to_atom(str_Function_5),
  #    reset: String.to_integer(oh_to_zero(strip_apostrophes(str_Reset))),
  #    notes: strip_apostrophes(str_Notes)
  #  }
  end

  def mux_pad_function_gpio() do
     mux_pad_list = Atomix.Reader.get(:mux_pad_list_4_10)
     functions = all_mux_pad_functions()
     functions_with_gpio = for function <- functions do
       pad = Enum.find(mux_pad_list, fn pad ->
          pad.function_0 == function ||
          pad.function_1 == function ||
          pad.function_2 == function ||
          pad.function_3 == function ||
          pad.function_4 == function ||
          pad.function_5 == function
       end)
       {function, pad[:GPIO]}
     end
     functions_with_gpio
  end
end
