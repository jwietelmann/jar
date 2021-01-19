defmodule JarTest do
  @moduledoc """
  These tests deal with API endpoints that are available in the API sandbox.

  HTTP responses are mocked when `config :jar, Jar.Config, mock_http: true`,
  which is part of the default test configuration.
  """
  use ExUnit.Case
  doctest Jar

  import JarTest.Factory
  import Tesla.Mock

  setup_all do
    [client: build(:sandbox_client)]
  end

  setup do
    mock(fn
      %{method: :get, url: "https://api.sandbox.taxjar.com/v2/categories"} ->
        %Tesla.Env{
          status: 200,
          body: %{categories: [%{name: "", product_tax_code: "", description: ""}]}
        }

      %{method: :post, url: "https://api.sandbox.taxjar.com/v2/taxes"} ->
        %Tesla.Env{
          status: 200,
          body: %{tax: %{jurisdictions: %{}, breakdown: %{}}}
        }

      %{method: :get, url: "https://api.sandbox.taxjar.com/v2/transactions/orders"} ->
        %Tesla.Env{
          status: 200,
          body: %{orders: []}
        }

      %{method: :get, url: "https://api.sandbox.taxjar.com/v2/transactions/refunds"} ->
        %Tesla.Env{
          status: 200,
          body: %{refunds: []}
        }

      %{method: :get, url: "https://api.sandbox.taxjar.com/v2/nexus/regions"} ->
        %Tesla.Env{
          status: 200,
          body: %{regions: []}
        }

      %{method: :get, url: "https://api.sandbox.taxjar.com/v2/summary_rates"} ->
        %Tesla.Env{
          status: 200,
          body: %{summary_rates: []}
        }
    end)

    :ok
  end

  test "`list_tax_categories` returns tax categories", %{client: client} do
    assert {:ok, %{categories: categories}} = Jar.list_tax_categories(client)
    assert [cat | _] = categories
    assert %{name: _, product_tax_code: _, description: _} = cat
  end

  test "`calculate_sales_tax` returns tax calculation", %{client: client} do
    assert {:ok, %{tax: tax}} = Jar.calculate_sales_tax(client, build(:tax_calc_params))
    assert %{jurisdictions: %{}, breakdown: %{}} = tax
  end

  test "`list_orders` returns order transactions", %{client: client} do
    assert {:ok, %{orders: orders}} = Jar.list_orders(client, build(:list_orders_params))
    assert is_list(orders)
  end

  test "`list_refunds` returns refund transactions", %{client: client} do
    assert {:ok, %{refunds: refunds}} = Jar.list_refunds(client, build(:list_refunds_params))
    assert is_list(refunds)
  end

  test "`list_nexus_regions` returns nexus regions", %{client: client} do
    assert {:ok, %{regions: regions}} = Jar.list_nexus_regions(client)
    assert is_list(regions)
  end

  test "`list_summary_rates` returns summary rates", %{client: client} do
    assert {:ok, %{summary_rates: summary_rates}} = Jar.list_summary_rates(client)
    assert is_list(summary_rates)
  end
end
