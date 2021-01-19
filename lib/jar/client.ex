defmodule Jar.Client do
  @moduledoc """
  Module for configuring our HTTP client to interact with the TaxJar API.
  """

  @doc """
  Takes a `%Jar.Config{}` or the valid fields of a `%Jar.Config{}` as an enumerable.
  Returns a `%Tesla.Client{}` that is configured to speak with the TaxJar API.
  """

  def new(%Jar.Config{} = config) do
    base_url =
      if config.sandbox do
        "https://api.sandbox.taxjar.com/#{config.version}"
      else
        "https://api.taxjar.com/#{config.version}"
      end

    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      # NOTE: Obviously there are dangers with converting an unknown number of strings to atoms.
      # In this case we will trust that TaxJar's API has a sane, deterministic number of possible keys.
      {Tesla.Middleware.JSON, engine_opts: [keys: :atoms]},
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{config.token}"}]},
      {Tesla.Middleware.Logger, debug: config.debug}
    ]

    if config.mock_http do
      Tesla.client(middleware, Tesla.Mock)
    else
      Tesla.client(middleware)
    end
  end

  def new(config) do
    config
    |> Jar.Config.new()
    |> new()
  end
end
