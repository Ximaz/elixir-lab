# Sources
# https://hexdocs.pm/elixir/comprehensions.html
# https://stackoverflow.com/questions/41313995/elixir-convert-integer-to-unicode-character
# https://elixirforum.com/t/multiple-guards-in-elixir/11327/3
# https://github.com/elixir-lang/elixir/blob/v1.6/CHANGELOG.md#defguard-and-defguardp
# Guards in Elixir : https://www.youtube.com/watch?v=fJbL7YrHrUA

defmodule Day03 do
  defp my_print_comb_printable(n, s \\ 3)
  when is_integer(n) and is_integer(s) and s > 0 do
    digits = Integer.digits(n)
    Enum.count(digits) >= (s - 1) and Enum.uniq(digits) |> Enum.sort == digits
  end

  def my_print_alpha do
    IO.puts(List.to_string(Enum.to_list(97..122)))
  end

  def my_print_revalpha do
    IO.puts(List.to_string(Enum.to_list(122..97)))
  end

  def my_print_digits do
    IO.puts(List.to_string(Enum.to_list(48..57)))
  end

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
