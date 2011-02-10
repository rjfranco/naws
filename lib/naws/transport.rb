require 'naws'

class Naws::Transport

  def initialize
    # For any async implementation which needs a mutex
    @mutex = Mutex.new
  end

  def execute(request, response_class, &callback)
    if callback
      async_execute(request) do |result|
        callback.call(response_class.new(result))
      end
    else
      response_class.new(sync_execute(request))
    end
  end

  protected

  def async_execute(request, &callback)
    raise NotImplementedError, "This transport does not support asynchronous execution"
  end

  def sync_execute(request)
    raise NotImplementedError, "Inheritors of Naws::Transport must implement #sync_execute"
  end

end
