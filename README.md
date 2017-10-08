# Expire

A simple mechanism to expire Elixir processes - for example a GenServer - after a given time span of inactivity.

## Design goals

* Good interface
* Minimal overhead
* Obvious implementation

## Interface

Setup the expiration watchdog in GenServer.init/3:

```
Expire.start __MODULE__, 2000
```

First argument must be any unique ID, second argument is the first / default expiration. Your GenServer now has to ping the watchdog to prevent expiration:

```
Expire.ping __MODULE__
```
This will renew the last / default expiration time. Optionally a new expiration can be given:
```
Expire.ping __MODULE__, 1000
```
Expiration only ever will get expanded, not shortened by later, shorter intervals.


## Limitation

Doesn't work too well with short expirations. Should be fine with anyting in the seconds range. My own usecase is several minutes.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `genserver_expire` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:genserver_expire, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/genserver_expire](https://hexdocs.pm/genserver_expire).

