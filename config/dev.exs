import Config

config :walkie_talkie, WalkieTalkie.Repo,
  username: System.get_env("DB_USERNAME") || "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  port: System.get_env("DB_PORT") || 5432,
  database: System.get_env("DB_NAME") || "walkie_talkie_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "1q4pCqLTnmse2Qao1Hdx+fZyKWYLGVQ89jEdhWggrYvvpB3LBWRHOSmUp9XL69wC",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

config :walkie_talkie, WalkieTalkieWeb.Endpoint,
  https: [
    port: 4443,
    cipher_suite: :strong,
    otp_app: :walkie_talkie,
    keyfile: System.get_env("SSL_KEY_PATH"),
    certfile: System.get_env("SSL_CERT_PATH")
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/walkie_talkie_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :walkie_talkie, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false
