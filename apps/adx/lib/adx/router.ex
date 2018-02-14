defmodule Adx.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:multipart],
                     pass:  ["application/json"]
                   #  json_decoder: Poison
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  post "/adx" do
    IO.inspect conn.body_params
    ret = Dsp.Dispatch.request(conn.body_params)
    send_resp(conn, 200, inspect(ret))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
