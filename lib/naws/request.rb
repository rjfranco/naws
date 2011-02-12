require 'time'

# The base class for all AWS requests. You should not use this class directly.
# Its subclasses provide the functionality for specific types of AWS request.
# This class handles basic configuration, header management, URI generation,
# and authentication.
class Naws::Request

  attr_reader :path, :method, :response_class

  # Constructs a new AWS request object.
  # +context+:: must be a Naws::Context.
  # +params+:: a hash of arguments used to construct the XML body or query 
  # string.
  # +options+:: any values used to configure the request which are not
  # included in the XML body or query string (headers, for example).
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

  # Returns a frozen hash of HTTP headers for this request. 
  def headers
    @output_headers ||= begin
      h = @headers.dup
      add_headers(h)
      h.freeze
    end
  end

  # Forwards this request to its context to be executed via the selected
  # transport.
  def execute
    @context.execute_request(self)
  end

  # The URI to which this request will be sent, including the query string.
  # Returns a URI object.
  def uri
    new_uri = @context.uri.dup
    new_uri.path = new_uri.path + path
    new_uri
  end
  
  # The body which will be included in a PUT or POST request.
  def body
    nil
  end

  def path
    interpolated_path
  end

  protected

    def interpolated_path
      @path.gsub(/:([a-z0-9_]+)/) {
        @params[$1.to_sym]
      }
    end

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
      "AWS3-HTTPS AWSAccessKeyId=#{auth.access_key_id},Algorithm=Hmac#{auth.algorithm},Signature=#{auth.aws_signature(date_header)}"
    end

    def add_headers(h)
      h["x-amz-date"] = date_header
      h["X-Amzn-Authorization"] = auth_header
    end

end
