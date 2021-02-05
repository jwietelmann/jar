# Jar

An example TaxJar API client.

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

To prevent you from accidentally altering your live production data or related charges on your TaxJar bill, tests for these endpoints are set up to always run against mocks,
regardless of test configuration. When altering test code, take care to ensure that this behavior is maintained.

See `prod_only_endpoints_test.exs` and the `always_mocked_production_client_factory/0` function in `test/support/factory.ex`.
