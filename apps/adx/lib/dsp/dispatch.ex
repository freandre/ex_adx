defmodule Dsp.Dispatch do
  use GenServer

  # Client

  def start_link(lst_dsp) when is_list(lst_dsp) do
    GenServer.start_link(__MODULE__, lst_dsp, name: :dispatch)
  end

  def init(lst_dsp) do
    {:ok, lst_dsp}
  end

  def request(request) do
    GenServer.call(:dispatch, {:request, request})
    |> Enum.filter(&Dsp.Validator.validate(request, &1))
    |> Dsp.Election.select_response()
  end

  # Server (callbacks)
  def handle_call({:request, request}, _from, lst_dsp) do
    ret =
      lst_dsp
      |> Dsp.Election.select_dsp
      |> Enum.map(&Task.async(fn -> Dsp.Connector.request(&1, request) end))
      |> Enum.map(&Task.await/1)

    {:reply, ret, lst_dsp}
  end

  def handle_info(_, lst_dsp) do
    {:noreply, lst_dsp}
  end
end
