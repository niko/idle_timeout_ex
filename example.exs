defmodule EchoGenServer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok )
  end

  def echo(server, msg) do
    GenServer.call(server, {:echo, msg})
  end

  ## Server Callbacks

  def init(:ok) do
    IdleTimeout.start __MODULE__, 2000

    {:ok, :state}
  end

  def handle_call({:echo, msg}, _from, state) do
    IdleTimeout.ping __MODULE__, 1000
    {:reply, msg, state}
  end

end

{:ok, server} = EchoGenServer.start_link

Enum.map(1..3, fn i ->
  IO.inspect EchoGenServer.echo server, i
  Process.sleep i*1000
end)

