class Naws::Response

  def initialize(options = {})
    @status = options[:status]
    @body = options[:body]
    @headers = options[:headers]
  end

end
