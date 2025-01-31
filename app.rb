require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

get("/") do
  access_key = ENV.fetch("EXCHANGE_RATES")
  url = "https://api.exchangerate.host/list?access_key=#{access_key}"
  exchange_rate_response = HTTP.get(url)
  exchange_parsed_response = JSON.parse(exchange_rate_response)
  @currencies = exchange_parsed_response.fetch("currencies").keys
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  access_key = ENV.fetch("EXCHANGE_RATES")
  url = "https://api.exchangerate.host/list?access_key=#{access_key}"
  exchange_rate_response = HTTP.get(url)
  exchange_parsed_response = JSON.parse(exchange_rate_response)
  @currencies = exchange_parsed_response.fetch("currencies").keys
  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")
  access_key = ENV.fetch("EXCHANGE_RATES")
  api_url = "https://api.exchangerate.host/convert?access_key=#{access_key}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  exchange_rate_response = HTTP.get(api_url)
  exchange_parsed_response = JSON.parse(exchange_rate_response)
  @result = exchange_parsed_response["result"]
  erb(:from_to_currency)
end
