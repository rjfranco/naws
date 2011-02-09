require 'time'

class Naws::Request

  attr_reader :path, :method, :response_class

  def initialize(context, params = {}, options = {})
    @context = context
    @params = params.dup
    @options = options.dup
    @headers = options.fetch(:headers, {}).dup
    set_path_and_method
    yield self if block_given?
    headers
    freeze
  end

  def headers
    @output_headers ||= begin
      h = @headers.dup
      h["x-amz-date"] = date_header
      h["X-Amzn-Authorization"] = auth_header
      h
    end
  end

  def to_xml
    ""
  end

  def execute
    @context.execute_request(self)
  end

  def uri
    new_uri = @context.uri.dup
    new_uri.path = new_uri.path + @path
    new_uri
  end

  protected

    def set_path_and_method
      begin
        @path = self.class.const_get("PATH")
      rescue NameError
      end
      begin
        @method = self.class.const_get("METHOD")
      rescue NameError
      end
      @response_class = self.class.const_get("RESPONSE")
    end

    def date_header
      @date_header ||= @context.aws_time.rfc2822
    end

    def auth_header
      auth = @context.authentication
      raise Naws::NoAuthenticationError unless auth
      "AWS3-HTTPS AWSAccessKeyId=#{auth.access_key_id},Algorithm=#{auth.algorithm},Signature=#{auth.aws_signature(date_header)}"
    end
end
