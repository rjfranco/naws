class Naws::Response

  def initialize(options = {})
    @status = options[:status]
    @body = options[:body]
    @headers = options[:headers]
    handle_error if error?
  end

  def error?
    @status < 200 or @status >= 300
  end

  protected

  def handle_error
    raise Naws::UpstreamError
  end

end
