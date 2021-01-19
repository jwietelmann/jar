# Jar

An example TaxJar API client.

## Running tests

Tests currently run against the Sandbox API, which is not ideal.
The API should really be mocked.

Create the following `config/test.secret.exs` file, substituting your own Sandbox API token:

```elixir
import Config

config :jar, Jar.Config, token: "your sandbox token"
```

Additionally, at least 3 functions can't be tested against the Sandbox API
because the Sandbox API does not support them at the moment.
