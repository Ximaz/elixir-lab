defmodule PasswordGeneratorTest do
  use ExUnit.Case
  doctest PasswordGenerator

  setup do
    options_type = %{
      lowercase: Enum.map(?a..?z, fn c -> <<c>> end),
      uppercase: Enum.map(?A..?Z, fn c -> <<c>> end),
      numbers: Enum.map(?0..?9, fn c -> <<c>> end),
      symbols: PasswordGenerator.symbols()
    }

    %{
      options_type: options_type,
    }
  end

  test "Returns a string" do
    options = %{
      length: 10,
      numbers: false,
      uppercase: false,
      symbols: false
    }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert is_bitstring(password)
  end

  test "Returns an error for invalid option" do
    options = %{ }
    assert { :error, _error } = PasswordGenerator.generate(options)
    options = %{ invalid: "Invalid option here !" }
    assert { :error, _error } = PasswordGenerator.generate(options)
  end

  test "Returns an error if options are not boolean values" do
    options = %{ numbers: 10 }
    assert { :error, _error } = PasswordGenerator.generate(options)
    options = %{ uppercase: "a" }
    assert { :error, _error } = PasswordGenerator.generate(options)
    options = %{ lowercase: ?a..?z }
    assert { :error, _error } = PasswordGenerator.generate(options)
  end

  test "Returns an error when length is <= 0" do
    options = %{ length: -1 }
    assert { :error, _error } = PasswordGenerator.generate(options)
    options = %{ length: 0 }
    assert { :error, _error } = PasswordGenerator.generate(options)
  end

  test "The password's length matches the option's length" do
    options = %{ length: 10 }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert String.length(password) === options.length
  end

  test "The password contains lowercase characters",
    %{ options_type: options_type }
  do
    options = %{ length: 10 }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert String.contains?(password, options_type.lowercase)
    refute String.contains?(password, options_type.uppercase)
    refute String.contains?(password, options_type.numbers)
    refute String.contains?(password, options_type.symbols)
  end

  test "The password contains uppercase characters",
    %{ options_type: options_type }
  do
    options = %{ length: 10, uppercase: true }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert String.contains?(password, options_type.lowercase)
    assert String.contains?(password, options_type.uppercase)
    refute String.contains?(password, options_type.numbers)
    refute String.contains?(password, options_type.symbols)
  end

  test "The password contains numbers characters",
    %{ options_type: options_type }
  do
    options = %{ length: 10, numbers: true }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert String.contains?(password, options_type.lowercase)
    refute String.contains?(password, options_type.uppercase)
    assert String.contains?(password, options_type.numbers)
    refute String.contains?(password, options_type.symbols)
  end

  test "The password contains symbols characters",
    %{ options_type: options_type }
  do
    options = %{ length: 10, symbols: true }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert String.contains?(password, options_type.lowercase)
    refute String.contains?(password, options_type.uppercase)
    refute String.contains?(password, options_type.numbers)
    assert String.contains?(password, options_type.symbols)
  end

  test "All at the same time",
    %{ options_type: options_type }
  do
    options = %{ length: 30, uppercase: true, numbers: true, symbols: true }
    assert { :ok, password } = PasswordGenerator.generate(options)
    assert String.length(password) === options.length
    assert String.contains?(password, options_type.lowercase)
    assert String.contains?(password, options_type.uppercase)
    assert String.contains?(password, options_type.numbers)
    assert String.contains?(password, options_type.symbols)
  end
end
