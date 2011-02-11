require 'naws/transport'
require 'naws/threaded_async_transport'
require 'net/http'
require 'net/https'

class Naws::NetHttpTransport < Naws::Transport

  # Please make sure you understand the security issues if you change this.
  # It's a constant so you'll have to make noise to change it.
  # http://www.rubyinside.com/how-to-cure-nethttps-risky-default-https-behavior-4010.html
  VERIFY_MODE = OpenSSL::SSL::VERIFY_PEER

  protected

    def sync_execute(request)
      http = Net::HTTP.new(request.uri.host, request.uri.port)
      http.use_ssl = true
      http.verify_mode = VERIFY_MODE
      response = nil
      http.start do |http|
        response = http.send_request(request.method, request.uri.request_uri, request.body, request.headers)
      end
      return({
        :status => response.code.to_i,
        :headers => response.to_hash,
        :body => response.body
      })
    end

end
