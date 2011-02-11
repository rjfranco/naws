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

  def collection(path, map)
    list = []
    each(path) do |ele|
      list << begin
        h = {}
        map.each do |subpath, key|
          h[key] = xtract(ele, subpath.dup)
        end
        h
      end
    end
    list
  end

  def get(path)
    xtract(@doc, path)
  end

  def get_attr(path, attr)
    raise NotImplementedError
  end

  protected

    def xtract(ele, path)
      texts = REXML::XPath.match(ele, path)
      texts = texts.map{|e| e.text }
      if texts.length == 1
        texts[0]
      elsif texts.empty?
        nil
      else
        texts
      end
    end
end
