# Atomix
![example workflow](https://github.com/taguniversalmachine/atomix/actions/workflows/elixir.yml/badge.svg)

Electronic Software Components for AtomVM on ESP32

Setup for your environment
Copy start.sh.example to start.sh and plug in your settings.
Copy docker-compose.yml.sample to docker-compose.yml and set your local directory

Then: docker-compose up

* LIN Bus Driver
* OnSemi AMIS-30623 Micro-stepping Motor Driver 
* RotorVision

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

