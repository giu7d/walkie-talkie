defmodule WalkieTalkie.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WalkieTalkieWeb.Telemetry,
      # Start the Ecto repository
      WalkieTalkie.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WalkieTalkie.PubSub},
      # Start Finch
      {Finch, name: WalkieTalkie.Finch},
      # Start the Endpoint (http/https)
      WalkieTalkieWeb.Endpoint
      # Start a worker by calling: WalkieTalkie.Worker.start_link(arg)
      # {WalkieTalkie.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
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
end
