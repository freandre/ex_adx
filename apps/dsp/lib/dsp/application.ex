defmodule Dsp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: Dsp.Router,
        options: [port: Application.get_env(:dsp, :dsp_port)]
      ),
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: Dsp.RouterSec,
        options: [port: Application.get_env(:dsp, :dsp_port_sec)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dsp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
