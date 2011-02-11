require 'naws/request'
require 'cgi'

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
