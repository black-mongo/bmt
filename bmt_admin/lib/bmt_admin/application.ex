defmodule BmtAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BmtAdminWeb.Telemetry,
      # Start the Ecto repository
      BmtAdmin.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BmtAdmin.PubSub},
      # Start Finch
      {Finch, name: BmtAdmin.Finch},
      # Start the Endpoint (http/https)
      BmtAdminWeb.Endpoint
      # Start a worker by calling: BmtAdmin.Worker.start_link(arg)
      # {BmtAdmin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BmtAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BmtAdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
