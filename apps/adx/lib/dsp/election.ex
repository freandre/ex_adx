defmodule Dsp.Election do
  def select_dsp(dsp_lst, _request) when is_list(dsp_lst) do
    dsp_lst
  end

  def select_best_offer({individually, bygroup}, request) do
    {individually_sum, individually_bid_lst} = select_individual_response(individually, request)

    {group_sum, group_bid_lst} = select_group_response(bygroup, request)

    if group_sum > individually_sum do
      group_bid_lst
    else
      individually_bid_lst
    end
  end

  defp select_individual_response(bid_map, _request) when is_map(bid_map) do
    bid_map
    |> Enum.reduce({0, []}, fn {_impid, bid_lst}, {sum, response_lst} ->
      best = Enum.max_by(bid_lst, &(&1.price))
      {sum + best.price, [best | response_lst]}
    end)
  end

  defp select_group_response(seatbids, _request) when is_list(seatbids) do
    seatbids
    |> Enum.reduce({0, []}, fn seatbid, {max_price, _} = acc ->
      bids = seatbid.bid

      sum_price =
        bids
        |> Enum.reduce(0, &(&2 + &1.price))

      if sum_price > max_price do
        {sum_price, bids}
      else
        acc
      end
    end)
  end
end
