defmodule App do
  defp my_function(n) when is_integer(n) do
    n * 2
  end
  def main do
    0..99 |> Enum.to_list |> Enum.map(&my_function/1)
  end
end
