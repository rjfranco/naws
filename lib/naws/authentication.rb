require 'naws'
require 'digest/sha2'

class Naws::Authentication

  attr_reader :access_key_id

  def initialize(aws_id, aws_key)
    @access_key_id = aws_id
    @secret_access_key = aws_key
  end

  def algorithm
    "SHA256"
  end

  def aws_signature(string)
    hash = Digest::SHA2.new
    hash << string
    hash << secret_access_key
    [hash.to_s].pack("m").chomp
  end

  protected

    def secret_access_key
      @secret_access_key
    end
end
