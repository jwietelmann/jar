# Jar

An example TaxJar API client.

## Usage

Jar can be configured globally.

```elixir
import Config

config :jar, Jar.Config,
  token: "your api token",
  sandbox: false,
  debug: false,
  mock_http: false
```

The global client can be fetched like this:

```elixir
client = Jar.global()
```

Clients can also be configured at runtime.

```elixir
client = Jar.configure(%{
  token: "your api token",
  sandbox: false,
  debug: false,
  mock_http: false
%})
```

API functions take your `%Jar.Client{}` as the first argument.
Here's an example API call to validate an address, using global configuration:

```elixir
Jar.validate_address(client, %{
  country: "US",
  state: "AZ",
  zip: "85297",
  city: "Gilbert",
  street: "3301 South Greenfield Rd"
})

# {:ok, %{addresses: [...]}}
```

## Testing

By default, tests run against mocks.

### Testing against the Sandbox 

To instead run tests against the live Sandbox API service, create the following `config/test.secret.exs` file, substituting your own Sandbox API token:

```elixir
import Config

config :jar, Jar.Config,
  token: "your token",
  mock_http: false
```

### Endpoints that the Sandbox doesn't support

At least 3 functions can't be tested against the live Sandbox API service.

To prevent you from accidentally altering your live production data or incurring charges on your TaxJar bill, tests for these endpoints are set up to always run against mocks,
regardless of test configuration. When altering test code, take care to ensure that this behavior is maintained.

See `prod_only_endpoints_test.exs` and the `always_mocked_production_client_factory/0` function in `test/support/factory.ex`.
