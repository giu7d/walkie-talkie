defmodule WalkieTalkie.Application do
  use Application

  require Membrane.Logger

  @cert_file_path "priv/integrated_turn_cert.pem"

  @impl true
  def start(_type, _args) do
    config_common_dtls_key_cert()
    create_integrated_turn_cert_file()

    children = [
      # Start Ecto repository
      WalkieTalkie.Repo,
      # Start Telemetry supervisor
      WalkieTalkieWeb.Telemetry,
      # Start PubSub system
      {Phoenix.PubSub, name: WalkieTalkie.PubSub},
      # Start HTTP Client and Endpoint
      {Finch, name: WalkieTalkie.Finch},
      WalkieTalkieWeb.Endpoint,
      # Start Membrane Room Registry
      {Registry, keys: :unique, name: WalkieTalkie.Room.Registry}
    ]

    opts = [strategy: :one_for_one, name: WalkieTalkie.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WalkieTalkieWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @impl true
  def stop(_state) do
    delete_cert_file()
    :ok
  end

  defp create_integrated_turn_cert_file() do
    cert_path = Application.fetch_env!(:walkie_talkie, :integrated_turn_cert)
    pkey_path = Application.fetch_env!(:walkie_talkie, :integrated_turn_pkey)

    if cert_path != nil and pkey_path != nil do
      cert = File.read!(cert_path)
      pkey = File.read!(pkey_path)

      File.touch!(@cert_file_path)
      File.chmod!(@cert_file_path, 0o600)
      File.write!(@cert_file_path, "#{cert}\n#{pkey}")

      Application.put_env(:walkie_talkie, :integrated_turn_cert_pkey, @cert_file_path)
    else
      Membrane.Logger.warn("""
      Integrated TURN certificate or private key path not specified.
      Integrated TURN will not handle TLS connections.
      """)
    end
  end

  defp delete_cert_file(), do: File.rm(@cert_file_path)

  defp config_common_dtls_key_cert() do
    IO.inspect("config_common_dtls_key_cert")
    {:ok, pid} = ExDTLS.start_link(client_mode: false, dtls_srtp: true)
    {:ok, pkey} = ExDTLS.get_pkey(pid)
    {:ok, cert} = ExDTLS.get_cert(pid)
    :ok = ExDTLS.stop(pid)
    Application.put_env(:walkie_talkie, :dtls_pkey, pkey)
    Application.put_env(:walkie_talkie, :dtls_cert, cert)
  end
end
