require './lib/baserest'
require 'rspec'

class APICalls
  config = YAML.load_file('./config/config.yml') 

=begin

request_headers_clone = {
  "Content-Type" => "application/json",
 # "Cookie": "token=e20c4b31d02bbf6"
  "Authorization": "Basic YWRtaW46cGFzc3dvcmQxMjM="
}

=end

  RSpec.describe 'Call different API methods' do
    client = BaseRestClient.new

    it 'Will work with a GET Method' do
     response =  client.get(config["get_booking"])
     expect(response).not_to be_empty
     puts response
    end

    it 'Will work with a POST Method for auth api' do
      response = client.post(config["get_auth"], config["request_body"], config["request_headers"])
      expect(response).not_to be_empty
      puts response
    end

    it 'Will work with a POST Method for booking api' do 
      response = client.post(config["get_booking"], config["request_bodyclone"], config["request_headers"])
      expect(response).not_to be_empty
      puts response
    end
=begin
    it 'Will work with a DELETE Method for booking api'
    ids_to_delete.each do |ids|
      begin
        response = client.delete("booking/#{ids}",{},  request_headers_clone)

    puts "Successfully Deleted #{ids}: #{response}"
      end
    rescue RestClient::ExceptionWithResponse => e 
      puts "Failed to Delete ids #{e.response}"
=end
  end
end
