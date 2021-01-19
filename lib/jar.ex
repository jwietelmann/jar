defmodule Jar do
  @moduledoc """
  Documentation for `Jar`.
  """

  @doc """
  Configures a %Tesla.Client{} for our HTTP requests.

      iex> Jar.configure(sandbox: true, token: "asdf").__struct__
      Tesla.Client
  """
  def configure(config), do: Jar.Client.new(config)

  @doc """
  Configures a %Tesla.Client{} using global configuration.

      config :jar, Jar.Config,
        version: "v2",
        sandbox: true,
        token: System.get_env("JAR_TOKEN"),
        debug: true
  """

  def global(), do: Jar.Client.new(Jar.Config.global())

  # Extract the body from successful responses.

  defp unpack_response({:ok, %{status: status, body: body}}) do
    atom =
      if status < 400 do
        :ok
      else
        :error
      end

    {atom, body}
  end

  defp unpack_response(error), do: error

  # Make a GET request to the TaxJar API.
  defp get(client, path, options \\ []) do
    client
    |> Tesla.get(path, options)
    |> unpack_response()
  end

  # Make a POST request to the TaxJar API.
  defp post(client, path, body, options \\ []) do
    client
    |> Tesla.post(path, body, options)
    |> unpack_response()
  end

  @doc """
  Lists tax categories.
  """
  def list_tax_categories(client), do: get(client, "/categories")

  @doc """
  Calculates sales tax.
  """
  def calculate_sales_tax(client, params), do: post(client, "/taxes", params)

  @doc """
  Lists order transactions.
  """
  def list_orders(client, params), do: get(client, "/transactions/orders", query: params)

  @doc """
  Lists refund transactions.
  """
  def list_refunds(client, params), do: get(client, "/transactions/refunds", query: params)

  # TODO: More transactions things

  @doc """
  Lists customers.
  """
  def list_customers(client), do: get(client, "/customers")

  # TODO: GET /rates/:zip

  @doc """
  Lists existing nexus locations for a TaxJar account.
  """
  def list_nexus_regions(client, params \\ []), do: get(client, "/nexus/regions", query: params)

  @doc """
  Validates an address.
  """
  def validate_address(client, params \\ []), do: post(client, "/addresses/validate", params)

  @doc """
  Validates an existing VAT identification number against VIES.
  """
  def validate_vat_number(client, params \\ []), do: post(client, "/validation", params)

  @doc """
  Lists minimum and average sales tax rates by region.
  """
  def list_summary_rates(client, params \\ []), do: get(client, "/summary_rates", query: params)
end
