# A simplified XML parsing interface which should be sufficient to parse the
# fairly simple, small XML documents AWS uses. This is an abstract superclass,
# and you should use a subclass (like Naws::RexmlXmlParser).
class Naws::XmlParser

  Element = Struct.new(:name, :attr, :text)

  def initialize(body)
    # Empty
  end
  protected :initialize

  def collection(path, map)
    raise NotImplementedError, "#hash not implemented in this parser!"
  end

  def each(path, &blk)
    raise NotImplementedError, "#each not implemented in this parser!"
  end

  def get(path)
    raise NotImplementedError, "#get not implemented in this parser!"
  end

  protected

    def element(name, attr, text)
      Element.new(name, attr, text)
    end

end
