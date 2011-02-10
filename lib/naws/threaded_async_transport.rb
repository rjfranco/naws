require 'naws'

# This implements a Thread-based async version of any synchronous transport.
# A Mutex is used to control access to sync_execute. As a result, only one
# request will run at once (however, it will not block the caller).
module Naws::ThreadedAsyncTransport

  protected

    def async_execute(request, &callback)
      Thread.new do
        r = nil
        @mutex.synchronize do
          r = sync_execute(request)
        end
        callback.call(r)
      end
    end

end
