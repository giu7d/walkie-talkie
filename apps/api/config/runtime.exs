import Config

defmodule ConfigParser do
  def parse_integrated_turn_ip(ip) do
    with {:ok, parsed_ip} <- ip |> to_charlist() |> :inet.parse_address() do
      parsed_ip
    else
      _ ->
        raise("""
        Bad integrated TURN IP format. Expected IPv4, got: \
        #{inspect(ip)}
        """)
    end
  end

  def parse_integrated_turn_port_range(range) do
    with [str1, str2] <- String.split(range, "-"),
         from when from in 0..65_535 <- String.to_integer(str1),
         to when to in from..65_535 and from <= to <- String.to_integer(str2) do
      {from, to}
    else
      _else ->
        raise("""
        Bad INTEGRATED_TURN_PORT_RANGE enviroment variable value. Expected "from-to", where `from` and `to` \
        are numbers between 0 and 65535 and `from` is not bigger than `to`, got: \
        #{inspect(range)}
        """)
    end
  end

  def parse_port_number(nil, _var_name), do: nil

  def parse_port_number(var_value, var_name) do
    with {port, _sufix} when port in 1..65535 <- Integer.parse(var_value) do
      port
    else
      _var ->
        raise(
          "Bad #{var_name} enviroment variable value. Expected valid port number, got: #{inspect(var_value)}"
        )
    end
  end

  def parse_metrics_scrape_interval(nil), do: nil

  def parse_metrics_scrape_interval(interval) do
    with {number, _sufix} when number >= 1 <- Integer.parse(interval) do
      number
    else
      _var ->
        raise "Bad METRICS_SCRAPE_INTERVAL enviroment variable value. Expected positive integer, got: #{interval}"
    end
  end

  def parse_store_metrics("true"), do: true

  def parse_store_metrics("false"), do: false

  def parse_store_metrics(invalid_value) do
    raise "Bad STORE_METRICS enviroment variable value. Expected \"true\" or \"false\", got: #{invalid_value}"
  end
end

config :walkie_talkie,
  integrated_turn_ip:
    "EXTERNAL_IP"
    |> System.get_env("127.0.0.1")
    |> ConfigParser.parse_integrated_turn_ip(),
  integrated_turn_port_range:
    "INTEGRATED_TURN_PORT_RANGE"
    |> System.get_env("50000-59999")
    |> ConfigParser.parse_integrated_turn_port_range(),
  integrated_tcp_turn_port:
    "INTEGRATED_TCP_TURN_PORT"
    |> System.get_env()
    |> ConfigParser.parse_port_number("INTEGRATED_TCP_TURN_PORT"),
  integrated_tls_turn_port:
    "INTEGRATED_TLS_TURN_PORT"
    |> System.get_env()
    |> ConfigParser.parse_port_number("INTEGRATED_TLS_TURN_PORT"),
  integrated_turn_pkey:
    "INTEGRATED_TURN_PKEY"
    |> System.get_env(),
  integrated_turn_cert:
    "INTEGRATED_TURN_CERT"
    |> System.get_env(),
  integrated_turn_domain:
    "VIRTUAL_HOST"
    |> System.get_env(),
  store_metrics:
    "STORE_METRICS"
    |> System.get_env("false")
    |> ConfigParser.parse_store_metrics(),
  metrics_scrape_interval:
    "METRICS_SCRAPE_INTERVAL"
    |> System.get_env("1")
    |> ConfigParser.parse_metrics_scrape_interval()

if System.get_env("PHX_SERVER") do
  config :walkie_talkie, WalkieTalkieWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :walkie_talkie, WalkieTalkie.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  _protocol = if System.get_env("USE_TLS", "false") == "true", do: :https, else: :http
  host = System.get_env("VIRTUAL_HOST") || "localhost"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :walkie_talkie, WalkieTalkieWeb.Endpoint,
    url: [
      host: host,
      port: 443,
      scheme: "https"
    ],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end

config :opentelemetry, :resource,
  service: [
    name: "walkie_talkie",
    namespace: "walkie_talkie"
  ]

config :opentelemetry, traces_exporter: :none
