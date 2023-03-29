import Config

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: WalkieTalkie.Finch

config :logger, level: :info
