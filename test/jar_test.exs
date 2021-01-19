defmodule JarTest do
  use ExUnit.Case
  doctest Jar

  import JarTest.Factory

  test "`configure` creates a %Tesla.Client{} when passed a valid set of vars or %Jar.Config{}" do
    config_vars = [version: "v2", sandbox: true, debug: true, token: "foo"]
    config = Jar.Config.new(config_vars)

    assert %Jar.Config{} = config
    assert %Tesla.Client{} = Jar.configure(config)
    assert %Tesla.Client{} = Jar.configure(config_vars)
  end

  test "`global` creates a %Tesla.Client{}" do
    assert %Tesla.Client{} = Jar.global()
  end

  setup_all do
    [client: Jar.global()]
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

  # TODO: `list_customers` is not in the sandbox API.
  # Use a production API token to test this endpoint in particular.

  # test "`list_customers` returns customers", %{client: client} do
  #   assert {:ok, %{customers: customers}} = Jar.list_customers(client)
  #   assert is_list(customers)
  # end

  test "`list_nexus_regions` returns nexus regions", %{client: client} do
    assert {:ok, %{regions: regions}} = Jar.list_nexus_regions(client)
    assert is_list(regions)
  end

  # TODO: `validate_address` is not in the sandbox API.
  # Use a production API token to test this endpoint in particular.

  # test "`validate_address` returns address validation info", %{client: client} do
  #   assert {:ok, %{addresses: addresses}} = Jar.validate_address(client)
  #   assert is_list(addresses)
  # end

  # TODO: TaxJar doesn't even mention if this API endpoint is sandbox-supported here:
  # https://support.taxjar.com/article/677-which-sandbox-endpoints-are-currently-supported
  # Based on initial tests it's probably not.
  # Use a production API token to test this endpoint in particular.

  # test "`validate_vat_number` returns address validation info", %{client: client} do
  #   assert {:ok, %{validation: validation}} = Jar.validate_vat_number(client) |> IO.inspect()
  #   assert %{valid: _, exists: _, vies_available: _, vies_response: %{}} = validation
  # end

  test "`list_summary_rates` returns summary rates", %{client: client} do
    assert {:ok, %{summary_rates: summary_rates}} = Jar.list_summary_rates(client)
    assert is_list(summary_rates)
  end
end
