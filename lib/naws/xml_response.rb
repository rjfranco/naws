require 'naws/response'
require 'naws/rexml_xml_parser'

class Naws::XmlResponse < Naws::Response

  @@parser_class = Naws::RexmlXmlParser
  def self.parser_class() @@parser_class end
  def self.parser_class=(v) @@parser_class = v end

  def initialize(options = {})
    @document = Naws::XmlResponse.parser_class.new(options[:body])
    super
  end

  def xpath_collection(path, map)
    @document.collection(path, map)
  end

  def xpath_each(path, &blk)
    @document.each(path, &blk)
  end

  def xpath(path)
    @document.get(path)
  end
  
  alias [] xpath

  protected

    def handle_error
      raise Naws::UpstreamError.new(upstream_error_message)
    end

    def upstream_error_message
      "#{xpath("//Error/Code")}: #{xpath("//Error/Message")}"
    end


end
