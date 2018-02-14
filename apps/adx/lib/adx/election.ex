defmodule Adx.Election do
  def choose(response_lst) when is_list(response_lst) do
    case response_lst do
      [h | _] -> h
      _ -> nil
    end
  end
end
