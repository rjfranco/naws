require 'naws/transport'
require 'naws/threaded_async_transport'
require 'net/http'
require 'net/https'

# A Naws Transport implemented using Ruby's built-in Net::HTTP library.
#
# Asynchronous execution is supported with a *big caveat*: it is implemented
# using Ruby threading, which in some versions of Ruby will be useless or worse
# than useless for this purpose. I haven't yet intensively tested threaded
# async. User beware.
class Naws::NetHttpTransport < Naws::Transport
  include Naws::ThreadedAsyncTransport

  # Please make sure you understand the security issues if you change this.
  # It's a constant so you'll have to make noise to change it.
  # http://www.rubyinside.com/how-to-cure-nethttps-risky-default-https-behavior-4010.html
  VERIFY_MODE = OpenSSL::SSL::VERIFY_PEER

  protected

    # TODO: This should support both HTTP and HTTPS operation. Right now, it's
    # HTTPS only.
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
