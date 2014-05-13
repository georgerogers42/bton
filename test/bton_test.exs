defmodule BtonTest do
  use ExUnit.Case
  import Bton.Test.Helpers
  # ExUnit.configure trace: true

  rs(10)
  rs(-167)
  rs(10.25)
  rs(-6.0252)
  rs("Hello World!")
  rs(["Hello World", 1.25, 2, [1,2], %{2 => 5}])
  rs(%{"black" => "sabbath", [1,2] => %{3 => 4}})
end
