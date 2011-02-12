require 'naws'

# A Naws Transport is responsible for delivering requests across HTTP and
# returning response data. The requests it receives are subclassed from
# Naws::Request, and it is provided with a response class which receives the
# headers, body, and HTTP status of the response.
#
# Transports should always support synchronous operation, which is triggered by
# calling #execute without a block. Transports may also support asynchronous
# operation, where the block passed to #execute is later invoked with the
# response as the single argument.
#
# Naws comes with Naws::NetHttpTransport, a transport which uses Ruby's built-in
# Net::HTTP library. If you have a preferred HTTP library, subclass
# Naws::Transport and implement #sync_execute and, optionally, #async_execute.
class Naws::Transport

  def initialize
    # For any async implementation which needs a mutex
    @mutex = Mutex.new
  end

  # Delivers a request and returns the response. +response_class+ should be a
  # class which takes a hash as its only argument. The hash will have the
  # following keys:
  #
  # :status:: The HTTP status code of the response (as an Integer).
  # :body:: A String containing the body of the response.
  # :headers:: A Hash of HTTP headers.
  #
  # If a +callback+ block is provided, the method will return immediately and
  # the request will be executed asynchronously. The +callback+ will be yielded
  # the response when the request completes.
  def execute(request, response_class, &callback) # :yields: response
    if callback
      async_execute(request) do |result|
        callback.call(response_class.new(result))
      end
    else
      response_class.new(sync_execute(request))
    end
  end

  protected

  # Subclasses may override this method to provide asynchronous request
  # execution. Implementations of this method must return immediately after
  # dispatching execution. When execution is completed, the hash described in
  # #execute must be yielded to +callback+.
  def async_execute(request, &callback)
    raise NotImplementedError, "This transport does not support asynchronous execution"
  end

  # Subclasses must override this method to provide asynchronous request
  # execution. Implementations of this method must block until the request is
  # completed. When execution is completed, the hash described in #execute must
  # be returned.
  def sync_execute(request)
    raise NotImplementedError, "Inheritors of Naws::Transport must implement #sync_execute"
  end

end
