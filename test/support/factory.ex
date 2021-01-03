defmodule JarTest.Factory do
  use ExMachina

  def client_factory() do
    %{
      # debug: true,
      sandbox: true,
      token: JarTest.Secrets.sandbox_token()
    }
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
end
