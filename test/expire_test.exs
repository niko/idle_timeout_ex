defmodule ExpireTest do
  use ExUnit.Case, async: true
#  doctest Expire

  setup do
    Process.flag(:trap_exit, true)
    :ok
  end

  def assert_exit_about t do
    delta = 20 + 0.1 * t # 20ms + 10% of the timeout
    t_start = NaiveDateTime.utc_now
    dt = receive do
      {:EXIT, _, :process_expired} -> NaiveDateTime.diff(NaiveDateTime.utc_now, t_start, :milliseconds)
    end
    assert_in_delta t, dt, delta
  end

  test "start 1" do
    Expire.start :some_id, 1
    assert_exit_about 1
  end

  test "start 100" do
    Expire.start :some_id, 100
    assert_exit_about 100
  end

  test "start default 1000" do
    Expire.start :some_id
    assert_exit_about 1000
  end

  test "start and ping" do
    Expire.start :some_id, 100
    Process.sleep 85
    Expire.ping :some_id, 100
    assert_exit_about 100
  end

  test "start and ping twice" do
    Expire.start :some_id, 100
    Process.sleep 85
    Expire.ping :some_id, 100
    Process.sleep 85
    Expire.ping :some_id, 100
    assert_exit_about 100
  end

  test "start, long ping, short ping" do
    Expire.start :some_id, 100
    Process.sleep 85
    Expire.ping :some_id, 200
    Process.sleep 10
    Expire.ping :some_id, 100
    assert_exit_about 190
  end
end
