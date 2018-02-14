defmodule Dsp.Connector do
  @timeout 100

  use GenServer

  # Client

  def start_link(%Dsp.Config{} = cfg) do
    GenServer.start_link(__MODULE__, cfg, name: String.to_atom(cfg.name))
  end

  def init(cfg) do
    {:ok, cfg}
  end

  def request(name, request) do
    try do
      GenServer.call(name, {:request, request}, @timeout)
    catch
      :exit, _value ->
        :nothing
    end
  end

  # Server (callbacks)
  def handle_call({:request, request}, _from, cfg) do
    # :timer.sleep(@timeout + 10)
    case ExRated.check_rate(cfg.name, 1000, cfg.qps) do
      {:ok, _} -> {:reply, call_dsp(request, cfg), cfg}
      _ -> {:reply, :nothing, cfg}
    end
  end

  defp call_dsp(request, cfg) do
    body = build_body(request)

    case HTTPoison.post(cfg.endpoint, Poison.encode!(body), [{"Content-Type", "application/json"}]) do
      {:ok, response} -> response.body
      _ -> :nothing
    end
  end

  defp build_body(request) do
    %{body: request}
  end
end
