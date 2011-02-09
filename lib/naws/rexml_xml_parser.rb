require 'naws/xml_parser'
require 'rexml/document'
require 'rexml/xpath'

class Naws::RexmlXmlParser < Naws::XmlParser
  
  def initialize(body)
    @doc = REXML::Document.new(body)
  end

  def each(path, &blk)
    REXML::XPath.each(@doc, path) do |ele|
      blk.call ele # REXML::Element quacks like we need
    end
  end

  def get(path)
    texts = REXML::XPath.match(@doc, path)
    texts = texts.map{|e| e.text }
    if texts.length == 1
      texts[0]
    else
      texts
    end
  end

  def get_attr(path, attr)
    raise NotImplementedError
  end

end
