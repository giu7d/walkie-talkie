defmodule WalkieTalkieApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WalkieTalkieApiWeb.Telemetry,
      # Start the Ecto repository
      WalkieTalkieApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WalkieTalkieApi.PubSub},
      # Start Finch
      {Finch, name: WalkieTalkieApi.Finch},
      # Start the Endpoint (http/https)
      WalkieTalkieApiWeb.Endpoint
      # Start a worker by calling: WalkieTalkieApi.Worker.start_link(arg)
      # {WalkieTalkieApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WalkieTalkieApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WalkieTalkieApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
