defmodule Dsp.Normalizer do
  def normalize_price(response, currency) do
    case response["cur"] == currency do
      true -> response
      false -> update_response(response, currency)
    end
  end

  defp update_response(response, currency) do
    response
    |> Map.replace!("cur", currency)
    |> Map.replace!("seatbid", generate_seatbids(response, currency))
  end

  defp generate_seatbids(response, currency) do
    rate = Exchangerate.rate(Map.get(response, "cur"), currency)

    response
    |> Map.get("seatbid")
    |> Enum.map(fn seatbid ->
      generate_seatbid(seatbid, rate)
    end)
  end

  defp generate_seatbid(seatbid, rate),
    do: Map.replace!(seatbid, "bid", generate_bids(Map.get(seatbid, "bid"), rate))

  defp generate_bids(bids, rate) do
    bids
    |> Enum.map(&Map.replace!(&1, "price", rate * Map.get(&1, "price")))
  end
end
