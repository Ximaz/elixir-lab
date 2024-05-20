# Sources
# https://hexdocs.pm/elixir/comprehensions.html
# https://stackoverflow.com/questions/41313995/elixir-convert-integer-to-unicode-character
# https://elixirforum.com/t/multiple-guards-in-elixir/11327/3
# https://github.com/elixir-lang/elixir/blob/v1.6/CHANGELOG.md#defguard-and-defguardp


defmodule Day03 do
  def is_printable(n) do
    [a, b, c] = [Integer.floor_div(n, 100), Integer.mod(Integer.floor_div(n, 10), 10), Integer.mod(n, 10)]
    a < b && b < c
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

  def my_isneg(n),
    do: (
      cond do
        n < 0 -> IO.puts('N')
        n >= 0 -> IO.puts('P')
      end)

  def my_print_comb do
    for n <- Enum.to_list(0..999), is_printable(n) do
      IO.puts(n)
    end
  end
end
