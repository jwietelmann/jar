import Config

config :jar, Jar.Config, version: "v2"

# import env-specific configs, if they exist

try do
  import_config "#{config_env()}.exs"
rescue
  _ -> nil
end

try do
  import_config "#{config_env()}.secret.exs"
rescue
  _ -> nil
end
