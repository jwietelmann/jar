defmodule ConfigTest do
  use ExUnit.Case

  test "`new` with invalid keys raises KeyError" do
    assert_raise KeyError, fn ->
      Jar.Config.new(foo: "bar")
    end
  end

  test "`global` returns a global configuration" do
    assert %Jar.Config{version: "v2", sandbox: sandbox, debug: debug, token: token} =
             Jar.Config.global()

    assert is_boolean(sandbox)
    assert is_boolean(debug)
    assert is_bitstring(token)
    refute token == ""
  end
end
