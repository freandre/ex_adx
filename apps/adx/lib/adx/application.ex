defmodule Adx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    {children, lst_dsp} =
      Application.get_env(:adx, :dsp_list)
      |> Enum.reduce({[], []}, fn dsp, {children, lst_dsp} ->
        dsp_name = String.to_atom(dsp[:name])

        {[
           Supervisor.child_spec({Dsp.Connector, struct(Dsp.Config, dsp)}, id: dsp_name)
           | children
         ], [dsp_name | lst_dsp]}
      end)

    children = [
      {Dsp.Dispatch, lst_dsp}
      | children
    ]

    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: Adx.Router,
        options: [port: Application.get_env(:adx, :adx_port)]
      )
      | children
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Adx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
