defmodule Jar.Config do
  defstruct version: "v2", sandbox: false, token: nil, debug: false

  @typedoc """
  Configuration for the API client.

  * `:version` - Defaults to `"v2"`, the only currently supported API version.
  * `:sandbox` - If `true`, requests use the Sandbox API. Defaults to `false`.
  * `:token` - Your API auth token.
  * `:debug` - If `true`, turns on Tesla debug mode. Defaults to `false`.
  """

  @type t :: %__MODULE__{
          version: String.t(),
          sandbox: Boolean.t(),
          token: String.t(),
          debug: Boolean.t()
        }

  @doc """
  Create a new `%Jar.Config{}`.
  """

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def global() do
    :jar
    |> Application.get_env(__MODULE__)
    |> new()
  end
end
