defmodule Adx.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  post "/adx" do
    ret = Dsp.Dispatch.request(conn.body_params)
    send_resp(conn, 200, inspect(ret))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
