defmodule Dsp.Dispatch do
  use GenServer

  # Client
  def start_link(cfg) do
    GenServer.start_link(__MODULE__, cfg, name: :dispatch)
  end

  def init(cfg) do
    {:ok, cfg}
  end

  def request(request) do
    {answer, adx_currency} = GenServer.call(:dispatch, {:request, request})

    answer
    |> Dsp.BidPreparator.filter_and_format(request, adx_currency)
    |> Dsp.BidPreparator.flatten_and_split()
    |> Dsp.Election.select_best_offer(request)
  end

  # Server (callbacks)
  def handle_call({:request, request}, _from, cfg) do
    ret =
      cfg[:dsp_list]
      |> Dsp.Election.select_dsp(request)
      |> Enum.map(&Task.async(fn -> Dsp.Connector.request(&1, request) end))
      |> Enum.map(&Task.await/1)

    {:reply, {ret, cfg[:adx_currency]}, cfg}
  end

  def handle_info(_, cfg) do
    {:noreply, cfg}
  end
end
