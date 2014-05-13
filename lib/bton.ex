defmodule Bton do
  use Application.Behaviour

  def parse(s) do
    [v] = parse(String.codepoints(iolist_to_binary(s)), [])
    v
  end
  defp parse([], v) do
    v
  end
  defp parse(cs=[d|_], stk) when d >= "0" and d <= "9" do
    {cs, n} = dec(cs, 0)
    parse(cs, [n|stk])
  end
  # defp parse([?x|cs], stk) do
    # hex(cs, stk)
  # end
  defp parse(["e"|cs], [d|stk]) do
    {cs, x} = dec(cs, 0)
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
  defp parse([_|cs], stk) do
    parse(cs, stk)
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
    <<c, b :: binary>> = c
    d = c - ?0
    dec(cs, acc * 10 + d)
  end
  defp dec(cs, acc) do
    {cs, acc}
  end
  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Bton.Supervisor.start_link
  end
end
