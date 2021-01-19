defmodule ProdOnlyEndpointsTest do
  @moduledoc """
  These tests deal with API endpoints that are not available in the API sandbox.
  They are only available in the live production API.

  HTTP requests/responses are always mocked, even when `config :jar, Jar.Config, mock_http: false`.
  """
  use ExUnit.Case

  import JarTest.Factory
  import Tesla.Mock

  setup_all do
    [client: build(:always_mocked_production_client)]
  end

  setup do
    mock(fn
      %{method: :get, url: "https://api.taxjar.com/v2/customers"} ->
        %Tesla.Env{
          status: 200,
          body: %{customers: []}
        }

      %{method: :post, url: "https://api.taxjar.com/v2/addresses/validate"} ->
        %Tesla.Env{
          status: 200,
          body: %{
            addresses: [
              %{
                zip: "85297-2176",
                street: "3301 S Greenfield Rd",
                state: "AZ",
                country: "US",
                city: "Gilbert"
              }
            ]
          }
        }

      %{method: :get, url: "https://api.taxjar.com/v2/validation"} ->
        %Tesla.Env{
          status: 200,
          body: %{
            validation: %{
              valid: true,
              exists: true,
              vies_available: true,
              vies_response: %{
                country_code: "FR",
                vat_number: "40303265045",
                request_date: "2016-02-10",
                valid: true,
                name: "SA SODIMAS",
                address: "11 RUE AMPERE\n26600 PONT DE L ISERE"
              }
            }
          }
        }
    end)

    :ok
  end

  test "`list_customers` returns customers", %{client: client} do
    assert {:ok, %{customers: customers}} = Jar.list_customers(client)
    assert is_list(customers)
  end

  test "`validate_address` returns address validation info", %{client: client} do
    assert {:ok, %{addresses: addresses}} =
             Jar.validate_address(client, build(:address_validation_params))

    assert is_list(addresses)
  end

  test "`validate_vat_number` returns address validation info", %{client: client} do
    assert {:ok, %{validation: validation}} =
             Jar.validate_vat_number(client, build(:vat_validation_params))

    assert %{valid: _, exists: _, vies_available: _, vies_response: vies_response} = validation

    assert %{country_code: _, vat_number: _, request_date: _, valid: _, name: _, address: _} =
             vies_response
  end
end
