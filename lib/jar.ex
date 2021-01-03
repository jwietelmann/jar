defmodule Jar do
  @moduledoc """
  Documentation for `Jar`.
  """

  @doc """
  Configures a %Tesla.Client{} for our HTTP requests.

  ## Examples

      iex> Jar.configure(sandbox: true, token: "asdf").__struct__
      Tesla.Client
  """
  def configure(config), do: Jar.Client.new(config)

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

  @doc """
  Makes a GET request to the TaxJar API.

  ## Examples

      iex> Jar.configure(token: "asdf")
      ...> |> Jar.get("/categories")
      ...> |> case do {:error, resp} -> resp.status end
      401
  """
  def get(client, path, options \\ []) do
    client
    |> Tesla.get(path, options)
    |> unpack_response()
  end

  def post(client, path, body, options \\ []) do
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
