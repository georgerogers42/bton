defmodule BtonTest do
  use ExUnit.Case

  test "numbers" do
    assert Bton.parse("12") == 12
  end
end
