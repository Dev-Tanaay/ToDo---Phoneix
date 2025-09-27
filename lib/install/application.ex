defmodule Install.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Install.Repo,
      # Start the Telemetry supervisor
      InstallWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Install.PubSub},
      # Start the Endpoint (http/https)
      InstallWeb.Endpoint
      # Start a worker by calling: Install.Worker.start_link(arg)
      # {Install.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Install.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InstallWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
