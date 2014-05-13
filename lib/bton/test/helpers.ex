defmodule Bton.Test.Helpers do
  defmacro rs(v) do
    {s, _} = Code.eval_quoted v
    quote do
      test unquote(inspect(s)) do
        v = unquote(v)
        assert Bton.read(Bton.print(v)) === v
      end
    end
  end
end
