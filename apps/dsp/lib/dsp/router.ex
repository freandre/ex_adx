defmodule Dsp.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  post "/dsp" do
  	send_resp(conn, 200,
 "{
   \"id\": \"1234567890\",
   \"ext\": {
     \"protocol\": \"5.3\"
   },
   \"seatbid\": [
     {
       \"bid\": [
         {
           \"id\": \"1\",
           \"impid\": \"102\",
           \"price\": 9.43,
           \"adid\": \"314\",
           \"cid\": \"42\",
           \"cat\": [\"IAB12\"],
           \"language\": \"en\",
           \"burl\":\"https://adserver.com/imp?impid=102&winprice=${AUCTION_PRICE}\",
           \"adm\": \"<a href=\"http://adserver.com/click?adid=12345&tracker=${CLICK_URL:URLENCODE}\"><img src=\"http://image1.cdn.com/impid=102\"/></a>\",
           \"nurl\": \"http://adserver.com/winnotice?impid=102&winprice=${AUCTION_PRICE}\",
           \"iurl\": \"http://adserver.com/preview?crid=314\",
           \"adomain\": [
             \"advertiserdomain.com\"
           ],
           \"ext\": {
             \"advertiser_name\": \"Coca-Cola\",
             \"agency_name\": \"CC-advertising\"
           }
         }
       ],
       \"seat\": \"4\"
     }
   ]
 }"
  		)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end