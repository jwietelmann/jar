defmodule Jar.Config do
  defstruct version: "v2", sandbox: false, token: nil, debug: false

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
