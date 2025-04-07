require 'rest-client'
require 'json'
require 'yaml'

class BaseRestClient
  def initialize
    # Load configuration from the YAML file
    config = YAML.load_file('./config/config.yml')

    # Set up instance variables from the YAML config
    @base_url = config['base_url']
    @api_key = config['api_key']
    @timeout = config['timeout']
    @max_retries = config['max_retries']
  end

  def get(endpoint, params = {})
    url = build_url(endpoint, params)
    response = RestClient.get(url, { timeout: @timeout })
    handle_response(response)
  end

  def post(endpoint, body = {}, headers = {})
    url = build_url(endpoint)
    response = RestClient.post(url, body.to_json, { 
      content_type: :json, 
      accept: :json,
      Authorization: "#{@api_key}"
    }.merge(headers))
    handle_response(response)
  end

  def delete(endpoint, params = {}, headers = {})
    url = build_url(endpoint, params)
    response = RestClient.delete(url, headers)
    handle_response(response)
  end

  private

  def build_url(endpoint, params = {})
    url = URI.join(@base_url, endpoint).to_s
    url += "?#{URI.encode_www_form(params)}" unless params.empty?
    url
  end

  def handle_response(response)
    case response.code
    when 200..299
      begin
        JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise "Error: Response body is not valid JSON. Response body: #{response.body}"
      end
    else
      raise "Error: HTTP #{response.code} - #{response.body}"
    end
  end
end
