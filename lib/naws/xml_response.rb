require 'naws/response'
require 'naws/rexml_xml_parser'

class Naws::XmlResponse < Naws::Response

  @@parser_class = Naws::RexmlXmlParser
  def self.parser_class() @@parser_class end
  def self.parser_class=(v) @@parser_class = v end

  def initialize(options = {})
    super
    @document = Naws::XmlResponse.parser_class.new(@body)
  end

  def xpath_each(path, &blk)
    @document.each(path, &blk)
  end

  def xpath(path)
    @document.get(path)
  end
  
  alias [] xpath

end
