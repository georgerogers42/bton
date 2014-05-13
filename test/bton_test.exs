defmodule BtonTest do
  use ExUnit.Case

  def rs(v) do
    assert Bton.read(Bton.print(v)) === v
  test "numbers" do
    assert Bton.parse("12") == 12
  end
  test "strings" do
    assert Bton.parse("5\"hello") == "hello"
  end
  test "read show" do
  end
end
