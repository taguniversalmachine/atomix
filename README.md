# Atomix
![example workflow](https://github.com/taguniversalmachine/atomix/actions/workflows/elixir.yml/badge.svg)

Digital Software Components for AtomVM on ESP32

### Configuration
Edit the config file for the environment you are working in.
Here is where you configure the I/O, Timers, Interrupts and other hardware peripherals.

Run the driver generator 

`mix atomix.gen.driver `

This will create nif files in _build/nif 
As well as the Elixir interface to match.

Included modules:

* GPIO

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `atomix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:atomix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/atomix](https://hexdocs.pm/atomix).

