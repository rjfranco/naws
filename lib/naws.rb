module Naws
  class NawsError < StandardError
    def initialize(message = nil)
      super(message || self.class.default_message)
    end
    def self.build(message)
      Class.new(self) do
        class << self
          attr_accessor :default_message
        end
        self.default_message = message
      end
    end
  end

  NoAuthenticationError = NawsError.build("No authentication was assigned to this context")
  NoContextError = NawsError.build("No context was assigned to this request")
  NoTransportError = NawsError.build("No transport was assigned to this context")
  UpstreamError = NawsError.build("Unknown AWS error")
end

require 'naws/util'
require 'naws/authentication'
require 'naws/response'
require 'naws/request'
require 'naws/xml_rest_request'
require 'naws/transport'
