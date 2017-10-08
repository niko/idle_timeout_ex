defmodule Expire do
  @moduledoc """
  Documentation for Expire.
  """

  @doc ~S"""
  start

  ## Examples

      iex> Expire.start :some_id
      #=> pid

  """
  def start(id, expiration \\ 1000) do
    pid = spawn_link fn -> watchdog expiration end
    Process.register pid, id
    pid
  end

  @doc """
  ping

  ## Examples

      iex> Expire.ping :some_id
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
      after expiration -> Process.exit(self(), :process_expired)
    end
  end

end

