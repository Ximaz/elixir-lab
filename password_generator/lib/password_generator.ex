defmodule PasswordGenerator do
  @moduledoc """
  `PasswordGenerator` module encapsulate all functions related to password
  generation, the main one being `PasswordGenerator.generate`.
  """

  @allowed_options [:length, :uppercase, :numbers, :symbols]
  @symbols "!#$?:+!-()[]{}%^*/\\~=<>."
  @spec generate(options :: map()) :: {:error, bitstring()} | {:ok, bitstring()}
  @spec priv_generate(options :: map()) :: bitstring()
  @spec validate_length_opt(boolean(), map()) :: {:error, bitstring()} | {:ok, bitstring()}
  @spec validate_bool_opt(boolean(), atom(), map()) :: {:error, bitstring()} | {:ok, bitstring()}
  @spec detect_invalid_opt(map()) :: {:error, bitstring()} | {:ok, bitstring()}
  @spec symbols() :: [binary()]
  @spec getc(atom()) :: <<_::8>>

  @doc """
  PasswordGenerator.generate

  This function is responsible for generating a password according to the
  `options` map it received as parameter. Here is an exmaple of such a map :

  PasswordGenerator.generate(%{
    length: 10,
    uppercase: true,
    numbers: true,
    symbols: true
  })

  ## Options
  length:     an unsigned number greater than 0 which represents the length of
              the generated password.

  uppercase:  a boolean to indicate whether or not to include uppercase
              characters in the generated password.

  numbers:    a boolean to indicate whether or not to include numerical
              characters in the generated password.

  symbols:    a boolean to indicate whether or not to include symbol characters
              in the generated password.

  """

  def generate(options) do
    opts_values = Enum.map(@allowed_options, fn o -> Map.has_key?(options, o) end)
    opts_idx = 0..(Enum.count(@allowed_options) - 1)

    predicates =
      Map.new(opts_idx, fn i -> {Enum.at(@allowed_options, i), Enum.at(opts_values, i)} end)

    {invalid_stmt, invalid_err} = detect_invalid_opt(options)
    {length_stmt, length_err} = validate_length_opt(predicates[:length], options)

    {uppercase_stmt, uppercase_err} =
      validate_bool_opt(predicates[:uppercase], :uppercase, options)

    {numbers_stmt, numbers_err} = validate_bool_opt(predicates[:numbers], :numbers, options)
    {symbols_stmt, symbols_err} = validate_bool_opt(predicates[:symbols], :symbols, options)

    case :error do
      ^invalid_stmt ->
        {:error, invalid_err}

      ^length_stmt ->
        {:error, length_err}

      ^uppercase_stmt ->
        {:error, uppercase_err}

      ^numbers_stmt ->
        {:error, numbers_err}

      ^symbols_stmt ->
        {:error, symbols_err}

      _ ->
        {:ok,
         priv_generate(Map.new(@allowed_options, fn k -> {k, Map.get(options, k, false)} end))}
    end
  end

  defp priv_generate(options) do
    length = options[:length]

    opts =
      [
        :lowercase
        | Enum.filter(Map.keys(options), fn k ->
            k !== :length and Map.get(options, k, false) !== false
          end)
      ]

    password =
      0..(length - 1)
      |> Enum.map(fn _ -> opts |> Enum.random() |> getc end)
      |> Enum.shuffle()
      |> Enum.join()
    password
  end

  defp validate_length_opt(false, _options), do: {:error, "You must supply a length"}

  defp validate_length_opt(true, options) do
    if !is_integer(options[:length]) || 0 >= options[:length] do
      {:error, "Invalid length was specified. It must be an integer > 0"}
    else
      {:ok, ""}
    end
  end

  defp validate_bool_opt(false, _key, _options), do: {:ok, ""}

  defp validate_bool_opt(true, key, options) do
    if !is_boolean(options[key]) do
      {:error, "The #{key} options must be a boolean"}
    else
      {:ok, ""}
    end
  end

  defp detect_invalid_opt(options) do
    invalid_keys? =
      options
      |> Map.keys()
      |> Enum.any?(fn k -> k not in @allowed_options end)

    if invalid_keys? do
      {:error, "Some options are unknowned. Please refer to the documentation"}
    else
      {:ok, ""}
    end
  end

  def symbols, do: @symbols |> String.split("", trim: true)

  defp getc(:lowercase) do
    <<Enum.random(?a..?z)::8>>
  end

  defp getc(:uppercase) do
    <<Enum.random(?A..?Z)::8>>
  end

  defp getc(:numbers) do
    <<Enum.random(?0..?9)::8>>
  end

  defp getc(:symbols) do
    symbols() |> Enum.random()
  end
end
