defmodule SspTest do
  use ExUnit.Case
  doctest Ssp

  test "greets the world" do
    assert Ssp.hello() == :world
  end
end
