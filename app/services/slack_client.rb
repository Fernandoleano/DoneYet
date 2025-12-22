require "net/http"
require "json"

class SlackClient
  BASE_URL = "https://slack.com/api"

  def initialize(token)
    @token = token
  end

  def post_message(channel:, text:, blocks: nil)
    payload = { channel: channel, text: text }
    payload[:blocks] = blocks if blocks

    post("chat.postMessage", payload)
  end

  def lookup_user_by_email(email)
    get("users.lookupByEmail", { email: email })
  end

  private

  def post(endpoint, body)
    uri = URI("#{BASE_URL}/#{endpoint}")
    req = Net::HTTP::Post.new(uri)
    req["Authorization"] = "Bearer #{@token}"
    req["Content-Type"] = "application/json; charset=utf-8"
    req.body = body.to_json

    execute(uri, req)
  end

  def get(endpoint, params)
    uri = URI("#{BASE_URL}/#{endpoint}")
    uri.query = URI.encode_www_form(params)
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{@token}"

    execute(uri, req)
  end

  def execute(uri, req)
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  rescue JSON::ParserError
    { "ok" => false, "error" => "json_parse_error", "body" => res.body }
  rescue StandardError => e
    { "ok" => false, "error" => "http_error", "message" => e.message }
  end
end
