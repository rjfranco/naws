require 'naws/transport'
require 'naws/threaded_async_transport'

# A Transport which returns canned responses, suitable for testing.
class Naws::DummyTransport < Naws::Transport
  include Naws::ThreadedAsyncTransport

  def initialize(responses = {}, &blk)
    @responses = responses
    @response_factory = blk || proc{}
  end

  protected

    def sync_execute(request)
      key = [request.method, request.uri.path].join(" ")
      data = @responses[key] || @response_factory.call(request) || {}
      data
    end

end
