require 'naws/request'
require 'cgi'

# A template for a simple get-based request.
# Example:
#   
#   class Naws::Baz::GetFooBarRequest < Naws::GetRequest
#     PATH = "/foobar/:id"
#   end
#
#   request = baz_context.request :get_foo_bar, :id => 123, :baz => "bat"
#   request.uri.request_uri # => "/foobar/123?baz=bat"
#   request.method # => "GET"
class Naws::GetRequest < Naws::Request

  def uri
    u = super
    u.query = query_string
    u
  end

  def method
    "GET"
  end

  protected

    def query_string
      query_arguments.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
    end

    def query_arguments
      @params
    end

end
