# Response wrapper to make Amazon responses easily parseable

require 'forwardable'
require 'multi_xml'

class Response
  extend Forwardable

  def_delegators :@response, :code, :body

  def initialize(response)
    @response = response
  end

  def to_h
    MultiXml.parse(body)
  end
end
