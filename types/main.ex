defmodule User do
  defstruct [:name, :age]
end

defmodule App do
  def main do
    users = [
      %User{name: "Malo", age: 20},
      %User{name: "Thomas", age: 18}
    ]
    Enum.each(users, fn %User{name: name, age: age} ->
      IO.puts("#{name} is #{age} years old.")
    end)
  end
end
