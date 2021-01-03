defmodule Jar.Client do
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

    Tesla.client(middleware)
  end

  def new(config) do
    config
    |> Jar.Config.new()
    |> new()
  end
end
