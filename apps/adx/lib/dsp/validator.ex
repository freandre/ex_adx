defmodule Dsp.Validator do
  def validate(response, _request) do
    Map.has_key?(response, "seatbid") && Map.get(response, "seatbid") != []
    # TODO add all functionnal test here
  end
end
