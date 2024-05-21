defmodule Alarity do
  defp foo, do: []
  defp foo(a), do: [a]
  defp foo(a, b), do: [a, b]
  defp foo(a, b, c), do: [a, b, c]

  def main do
    IO.inspect(foo())         # Alarity 0 (aka foo/0)
    IO.inspect(foo(1))        # Alarity 1 (aka foo/1)
    IO.inspect(foo(1, 2))     # Alarity 2 (aka foo/2)
    IO.inspect(foo(1, 2, 3))  # Alarity 3 (aka foo/3)
  end
end
