defmodule BtonTest do
  use ExUnit.Case

  test "numbers" do
    assert Bton.parse("12") == 12
  end
  test "strings" do
    assert Bton.parse("5\"hello") == "hello"
  end
end
