import Config

config :walkie_talkie, ecto_repos: [WalkieTalkie.Repo]

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: WalkieTalkieWeb.ErrorHTML, json: WalkieTalkieWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: WalkieTalkie.PubSub,
  live_view: [signing_salt: "K4/dBrsV"]

config :walkie_talkie, WalkieTalkie.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
