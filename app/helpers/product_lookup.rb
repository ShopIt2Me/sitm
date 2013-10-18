module ProductLookup
  # make instance methods available as class methods
  extend self

  def loadFromASIN asin
    req = ProductLookup.getRequestObject

    params = {
      'Operation'     => 'ItemSearch',
      'SearchIndex'   => 'Books',
      'Keywords'      => '1984'
    }

    @res = Response.new(req.get(query: params))
  end

  def getRequestObject
    req = Vacuum.new('US')
    req.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] ,
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['ASSOCIATE_TAG']
    )
  end
end

if $0 == __FILE__
end
