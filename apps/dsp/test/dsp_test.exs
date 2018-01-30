defmodule DspTest do
  use ExUnit.Case
  doctest Dsp

  test "greets the world" do
    assert Dsp.hello() == :world
  end
end
