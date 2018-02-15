defmodule Dsp.Router do
  use Plug.Router

  plug(:match)

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  post "/dsp" do
   data = ~s(
{
    "id": "IxexyLDIIk",
    "seatbid": [
        {
            "bid": [
                {
                    "id": "1",
                    "impid": "1",
                    "price": 0.751371,
                    "adid": "52a5516d29e435137c6f6e74",
                    "nurl": "http://ads.com/win/112770_1386565997?won=${AUCTION_PRICE}",
                    "adm": "<a href=\\"http://ads.com/click/112770_1386565997\\"><img src=\\"http://ads.com/img/112770_1386565997?won=${AUCTION_PRICE}\\" width=\\"728\\" height=\\"90\\" border=\\"0\\" alt=\\"Advertisement\\" /></a>",
                    "adomain": [
                        "ads.com"
                    ],
                    "iurl": "http://ads.com/112770_1386565997.jpeg",
                    "cid": "52a5516d29e435137c6f6e74",
                    "crid": "52a5516d29e435137c6f6e74_1386565997",
                    "attr": []
                }
            ],
            "seat": "2"
        }
    ],
    "cur": "USD"
})

    encoded = Poison.decode!(data)
    send_resp(conn, 200, Poison.encode!(encoded))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
