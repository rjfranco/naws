require 'uri'
require 'naws-route53/create_hosted_zone_request'

class Naws::Context

  def initialize(options = {})
    if options[:access_key_id].kind_of?(String) and options[:secret_access_key].kind_of?(String)
      self.authentication = Naws::Authentication.new(options[:access_key_id], options[:secret_access_key])
    else
      self.authentication = options[:authentication]
    end
    self.uri = options[:uri] if options[:uri]
    self.xmlns = options[:xmlns] if options[:xmlns]
    self.transport = options[:transport] if options[:transport]
  end

  attr_accessor :xmlns

  attr_reader :transport
  def transport=(value)
    if transport.kind_of?(Symbol)
      raise
      self.transport = resolve_transport_class.new
    else
      @transport = value
    end
  end

  attr_reader :uri
  def uri=(value)
    if value.kind_of?(URI)
      @uri = value
    else
      self.uri = URI.parse(value.to_s)
    end
  end

  attr_reader :authentication
  def authentication=(value)
    if value.nil? or value.respond_to?(:aws_signature)
      @authentication = value
    else
      raise ArgumentError, "authentication object must respond to #aws_signature"
    end
  end

  def request(name, params = {}, options = {})
    resolve_request_class("#{name}_request").new(self, params, options)
  end

  def execute_request(request)
    # TODO: some HTTPing
    request.response_class.new
  end

  # TODO: it should be possible to calibrate this to the published AWS time
  def aws_time
    Time.now
  end

  protected

    def resolve_request_class(name)
      Naws::Util.constantize(const_prefix + "::" + Naws::Util.camelize(name))
    end

    def resolve_transport_class(name)
      Naws::Util.constantize("Naws::Transport::" + Naws::Util.camelize("#{name}_transport"))
    end

    def const_prefix
      self.class.name.split("::")[0..-2].join("::")
    end

end
