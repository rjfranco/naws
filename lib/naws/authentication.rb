require 'naws'
require 'openssl'

class Naws::Authentication

  attr_reader :access_key_id

  def initialize(aws_id, aws_key)
    @access_key_id = aws_id
    @secret_access_key = aws_key
  end

  def algorithm
    "SHA1"
  end

  def aws_signature(string)
    hash = OpenSSL::Digest::Digest.new('sha1')
    [OpenSSL::HMAC.digest(hash, secret_access_key, string)].pack("m").chomp
  end

  protected

    def secret_access_key
      @secret_access_key
    end
end
