defmodule JarTest.Factory do
  use ExMachina

  def sandbox_client_factory() do
    Jar.Config.global()
    |> Map.merge(%{sandbox: true})
    |> Jar.configure()
  end

  def always_mocked_production_client_factory() do
    Jar.Config.global()
    # ALWAYS KEEP `mock_http: true` TO PREVENT LIVE API CALLS IN TESTS
    |> Map.merge(%{sandbox: false, mock_http: true})
    |> Jar.configure()
  end

  def tax_calc_params_factory() do
    %{
      from_country: "US",
      from_zip: "92093",
      from_state: "CA",
      from_city: "La Jolla",
      from_street: "9500 Gilman Drive",
      to_country: "US",
      to_zip: "90002",
      to_state: "CA",
      to_city: "Los Angeles",
      to_street: "1335 E 103rd St",
      amount: 15,
      shipping: 1.5,
      nexus_addresses: [
        %{
          id: "Main Location",
          country: "US",
          zip: "92093",
          state: "CA",
          city: "La Jolla",
          street: "9500 Gilman Drive"
        }
      ],
      line_items: [
        %{
          id: "1",
          quantity: 1,
          product_tax_code: "20010",
          unit_price: 15,
          discount: 0
        }
      ]
    }
  end

  def list_orders_params_factory() do
    %{
      from_transaction_date: "2015/05/01",
      to_transaction_date: "2015/05/31"
    }
  end

  def list_refunds_params_factory() do
    %{
      from_transaction_date: "2015/05/01",
      to_transaction_date: "2015/05/31"
    }
  end

  def address_validation_params_factory() do
    %{
      country: "US",
      state: "AZ",
      zip: "85297",
      city: "Gilbert",
      street: "3301 South Greenfield Rd"
    }
  end

  def vat_validation_params_factory() do
    %{
      vat: "FR40303265045"
    }
  end
end
