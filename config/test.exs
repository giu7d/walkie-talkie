import Config

config :walkie_talkie, WalkieTalkie.Repo,
  username: System.get_env("DB_USERNAME") || "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  port: System.get_env("DB_PORT") || 5432,
  database: "walkie_talkie_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rpXMs9/kl/ltsXYhRJ7YVOr1xys370dlBPT+pGRgx/S5ld+/Rg/cnEsU4z3vtGFo",
  server: false

config :walkie_talkie, WalkieTalkie.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
