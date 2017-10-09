# IdleTimeout

A simple mechanism to timeout idle Elixir processes - for example a GenServer - after a given period of inactivity.

## Design goals

* Good interface
* Minimal overhead
* Obvious implementation

## Interface

Setup the timeout watchdog in GenServer.init/3:

```
IdleTimeout.start __MODULE__, 2000
```

First argument must be any unique ID, second argument is the first / default timeout. Your GenServer now has to ping the watchdog to prevent timeout:

```
IdleTimeout.ping __MODULE__
```
This will renew the last / default timeout. Optionally a new timeout can be given:
```
IdleTimeout.ping __MODULE__, 1000
```
Timeout only ever will get expanded, not shortened by later, shorter intervals.


## Limitation

Doesn't work too well with short timeouts. Should be fine with anyting in the seconds range. My own usecase is several minutes.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `idle_timeout_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:idle_timeout_ex, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/idle_timeout_ex](https://hexdocs.pm/idle_timeout_ex).

