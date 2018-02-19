defmodule Dsp.Validator do
  def validate(response, _request) do
    response.seatbid != []
    # TODO add all functionnal test here
  end
end
