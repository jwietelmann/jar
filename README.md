# Jar

An example TaxJar API client.

## Running tests

Tests currently run against the Sandbox API, which is not ideal.
The API should really be mocked.

Additionally, at least 3 functions can't be tested against the Sandbox API
because the Sandbox API does not support them at the moment.

This is the quick hack I made for running the tests without commiting API tokens:

In the (gitignored) file `test/support/secrets.ex`, paste this and use your own sandbox token:

```elixir
defmodule JarTest.Secrets do
  def sandbox_token(), do: "your sandbox token here"
end
```
