defmodule Bton do
  use Application.Behaviour

  @doc "Converts the datastructure *d* to a BTON program"
  def print(d) do
    iolist_to_binary(emit(d))
  end
  defp emit(d) when is_integer d do
    if d < 0 do
      "d#{-d}-"
    else
      "d#{d}"
    end
  end
  defp emit(d) when is_float d do
    a = iolist_to_binary(:io_lib.format("~.4f", [d]))
    [x, y] = Regex.split ~r"\.", a
    a = binary_to_integer(String.strip(x <> y))
    "#{emit a}#{emit 4}e"
  end
  defp emit(b) when is_binary(b) do
    [emit(size(b)), '"', b]
  end
  defp emit(xs) when is_list(xs) do
    xs = Enum.map xs, fn(x) ->
      "#{emit(x)},"
    end
    ["[", xs, "]"]
  end
  defp emit(m) when is_map(m) do
    ps = Enum.map m, fn({k, v}) ->
      "#{emit(k)}#{emit(v)}:"
    end
    ["{", ps, "}"]
  end

  @doc "Takes a BTON String *s* and returns the datastructure the program returns"
  def read(s) do
    [v] = parse(String.codepoints(iolist_to_binary(s)), [])
    v
  end
  defp parse([], v) do
    v
  end
  defp parse(["d"|cs], stk) do
    {cs, n} = dec(cs, 0)
    parse(cs, [n|stk])
  end
  defp parse(cs=[d|_], stk) when d >= "0" and d <= "9" do
    parse(["d"|cs], stk)
  end
  # defp parse([?x|cs], stk) do
    # hex(cs, stk)
  # end
  defp parse(["-"|cs], [d|stk]) do
    parse(cs, [-d|stk])
  end
  defp parse(["e"|cs], [x,d|stk]) do
    parse(cs, [d / :math.pow(10, x)|stk])
  end
  defp parse(["{"|cs] , stk) do
    parse(cs, [%{}|stk])
  end
  defp parse(["["|cs], stk) do
    parse(cs, [[]|stk])
  end
  defp parse([","|cs], [e, a|stk]) do
    parse(cs, [[e|a]|stk])
  end
  defp parse(["]"|cs], [a|stk]) do
    parse(cs, [:lists.reverse(a)|stk])
  end
  defp parse([":"|cs], [v, k, m|stk]) do
    m = Map.put m, k, v
    parse(cs, [m|stk])
  end
  defp parse(["\""|cs], [l|stk]) do
    str(cs, stk, l)
  end
  defp parse(["}"|cs], stk) do
    parse(cs, stk)
  end
  defp parse([c|cs], stk) do
    cond do
      String.strip(c) === "" ->
        parse(cs, stk)
      c === "\n" ->
        parse(cs, stk)
    end
  end

  defp str(cs, stk, l) do
    {cs, s} = pstr(cs, l)
    parse(cs, [iolist_to_binary(s)|stk])
  end
  defp pstr(cs, 0) do
    {cs, []}
  end
  defp pstr([c|cs], l) do
    {cs, s} = pstr(cs, l-1)
    {cs, [c|s]}
  end

  defp dec([c|cs], acc) when c >= "0" and c <= "9" do
    <<c, _ :: binary>> = c
    d = c - ?0
    dec(cs, acc * 10 + d)
  end
  defp dec(cs, acc) do
    {cs, acc}
  end
  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    {:ok, self}
  end
end
