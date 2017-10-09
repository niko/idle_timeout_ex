defmodule IdleTimeout do
  @moduledoc """
A simple mechanism to timeout idle Elixir processes - for example a GenServer - after a given time span of inactivity.

## Design goals

* Good interface
* Minimal overhead
* Obvious implementation

## Interface

* Start your timeout with `IdleTimeout.start/1,2`.
* On activity renew the timeout with `IdleTimeout.ping/1,2`.
* Receive an `:EXIT` message when the timeout expires without activity.

## Overhead

A single linked process is spawned.

## Implementation.

The linked process `receive`s `:ping` messages. On timeout the process kills itself. Because it's linked it will kill the parent process as well.

  """

  @doc ~S"""
Setup the timeout watchdog - for example in GenServer.init/3:

```
IdleTimeout.start __MODULE__, 2000
```

First argument must be any unique ID (suitable for Process.register/2), second argument is the first / default timeout. Your GenServer now has to ping the watchdog to prevent timeout.

  ## Examples

      iex> IdleTimeout.start :some_id
      #=> pid

  """
  def start(id, expiration \\ 1000) do
    pid = spawn_link fn -> watchdog expiration end
    Process.register pid, id
    pid
  end

  @doc """
This will renew the last / default timeout. Optionally a new timeout can be given.

  ## Examples

      iex> IdleTimeout.ping :some_id
      {:ping, nil}

  """
  def ping(id, expiration \\ nil) do
    Process.alive?(Process.whereis id) && send id, {:ping, expiration}
  end

  defp watchdog(expiration) do
    t = NaiveDateTime.utc_now
    receive do
      {:ping, next_ex} ->
        if next_ex do
          dt = NaiveDateTime.diff NaiveDateTime.utc_now, t, :milliseconds
          rest_last_expiration = expiration - dt
          watchdog Enum.max([rest_last_expiration, next_ex])  # wait for the rest of the last expiration or the new expiration whatever is longer
        else
          watchdog expiration                                 # expand expiration time to last expiration again
        end
      after expiration -> Process.exit(self(), :process_timed_out)
    end
  end

end

