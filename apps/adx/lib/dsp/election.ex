defmodule Dsp.Election do

  def select_dsp(dsp_lst) when is_list(dsp_lst) do
  	dsp_lst
  end

  def select_response(response_lst) when is_list(response_lst) do
    case response_lst do
      [h | _] -> h
      _ -> nil
    end
  end
end
