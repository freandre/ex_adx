defmodule Exchangerate do
  use GenServer

  # Client
  def start_link(currency_list \\ []) when is_list(currency_list) do
    GenServer.start_link(__MODULE__, currency_list, name: :exchangerate)
  end

  def init(currency_list) do
    currency_map = build_cache(currency_list)
    schedule_work()
    {:ok, currency_map}
  end

  def rate(from_currency, to_currency) do
    GenServer.call(:exchangerate, {:rate, from_currency, to_currency})
  end

  # Server (callbacks)
  def handle_call({:rate, from_currency, to_currency}, _from, currency_map) do
    currency_map =
      case Map.has_key?(currency_map, from_currency) do
        false -> Map.put(currency_map, from_currency, request_rate(from_currency))
        _ -> currency_map
      end

    ret =
      currency_map
      |> Map.get(from_currency)
      |> Map.get(to_currency)

    {:reply, ret, currency_map}
  end

  def handle_info(:refresh, currency_map) do
    currency_map = build_cache(Map.keys(currency_map))
    schedule_work()
    {:noreply, currency_map}
  end

  defp schedule_work() do
    # in 30 minutes
    Process.send_after(self(), :refresh, 30 * 60 * 1000)
  end

  defp build_cache(currency_list) do
    currency_list
    |> Enum.map(&{&1, Task.async(fn -> request_rate(&1) end)})
    |> Enum.reduce(%{}, fn {currency, task}, acc ->
      Map.put(acc, currency, Task.await(task))
    end)
  end

  defp request_rate(currency) do
    HTTPoison.get!("https://api.fixer.io/latest?base=" <> currency).body
    |> Poison.decode!()
    |> Map.get("rates")
    |> Map.put(currency, 1)
  end
end
