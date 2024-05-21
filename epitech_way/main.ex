defmodule Day03 do
  # Resources
  # https://hexdocs.pm/elixir/comprehensions.html
  # https://stackoverflow.com/questions/41313995/elixir-convert-integer-to-unicode-character
  # https://elixirforum.com/t/multiple-guards-in-elixir/11327/3
  # https://github.com/elixir-lang/elixir/blob/v1.6/CHANGELOG.md#defguard-and-defguardp
  # Guards in Elixir : https://www.youtube.com/watch?v=fJbL7YrHrUA
  # https://stackoverflow.com/questions/66681743/how-to-check-if-the-elements-of-an-array-are-in-sequential-order-in-elixir
  # https://stackoverflow.com/questions/20732095/elixir-characters-range
  # https://stackoverflow.com/questions/71769514/what-does-the-operator-do-in-elixir

  defp my_print_comb_printable(n, s \\ 3)
  when is_integer(n) and is_integer(s) and s > 0 do
    digits = Integer.digits(n)
    Enum.count(digits) >= (s - 1) and digits |> Enum.uniq |> Enum.sort == digits
  end

  def my_print_alpha, do: ?a..?z |> Enum.to_list |> List.to_string |> IO.puts

  def my_print_revalpha, do: ?z..?a |> Enum.to_list |> List.to_string |> IO.puts

  def my_print_digits, do: ?0..?9 |> Enum.to_list |> List.to_string |> IO.puts

  def my_isneg(n) when is_number(n) and n < 0, do: IO.puts('N')

  def my_isneg(n) when is_number(n) and n >= 0, do: IO.puts('p')

  def my_print_comb do
    for n <- 0..999, my_print_comb_printable(n) do
      IO.puts(n)
    end
  end

  def my_print_comb2 do
    for i <- 0..99, j <- 0..99, i < j do
      IO.puts("#{i} #{j}")
    end
  end

  def my_print_combn(n) when is_integer(n) and n > 0 do
    for i <- 0..(10 ** n - 1), my_print_comb_printable(i, n) do
      IO.puts(i)
    end
  end
end

defmodule Day04 do
  # Resources
  # https://elixirforum.com/t/find-the-first-recurring-character-in-a-string/13717/2
  # https://stackoverflow.com/questions/25896762/how-can-pattern-matching-be-done-on-text

  def my_swap({a, b}), do: {b, a}

  def my_strlen(s) when is_bitstring(s) do
    s
    |> String.graphemes
    |> Enum.reduce_while(0, fn _, acc -> { :cont, acc + 1 } end)
  end

  def my_evil_str(s) when is_bitstring(s) do
    s
    |> String.graphemes
    |> Enum.reduce_while("", fn c, acc -> { :cont, c <> acc} end)
  end

  defp my_is_digit(<<c::size(8)>>), do: c in ?0..?9

  defp my_getnbr_parser(s) when is_bitstring(s) do
    s
    |> String.graphemes
    |> Enum.reduce_while({ 1, "" }, fn c, { sign, nb } ->
        if c in ["+", "-"] and nb == "",
        do: { :cont, { sign * (if c == "-", do: -1, else: 1), nb }},
        else: { :cont, { sign, nb <> c }} end)
  end

  def my_get_nth_digits([]), do: []
  def my_get_nth_digits([d | ds]) do
    if my_is_digit(d), do: [d | my_get_nth_digits(ds)], else: []
  end

  def my_getnbr_convertor([]), do: 0
  def my_getnbr_convertor([d | ds]) do
    String.to_integer(d) * (10 ** Enum.count(ds)) + my_getnbr_convertor(ds)
  end

  def my_getnbr(s) when is_bitstring(s) do
    { sign, nb } = my_getnbr_parser(s)
    sign * (nb |> String.graphemes |> my_get_nth_digits |> my_getnbr_convertor)
  end
end
