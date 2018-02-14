defmodule Dsp.Connector do

  @timeout 100

  use GenServer

  # Client

  def start_link(%Dsp.Config{} = cfg) do
    GenServer.start_link(__MODULE__, cfg, [name: String.to_atom(cfg.name)])
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
  def handle_call({:request, _request}, _from, cfg) do
  	#:timer.sleep(@timeout + 10)
  	case ExRated.check_rate(cfg.name, 1000, cfg.qps) do
  		{:ok, _} -> {:reply, :ok, cfg}
  		_ -> {:reply, :nothing, cfg}
  	end
  end

end
