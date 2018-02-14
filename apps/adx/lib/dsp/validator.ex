defmodule Dsp.Validator do
  def validate(_request, :nothing), do: false

  def validate(_request, _response) do
    true
  end
end
