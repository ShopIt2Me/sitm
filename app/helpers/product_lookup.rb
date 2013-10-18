# ProductLookup module takes care of querying Amazon API for products
#
# load_from_asin method receives batches of Amazon ASINS in the format of:
#   FORMAT: String => "ASIN1,ASIN2,ASIN3,..,ASIN10"
#
# And returns and array containing a hash for each product composed by
# the product attributes and its similar products, in the format of:
#   FORMAT: Array => [
#     {
#       :product_attributes => {
#         small_image: ''
#         medium_image: ''
#         large_image: ''
#         title: ''
#         price: ''
#         brand: ''
#         buylink: ''
#       }
#       :similar_products   => [
#         'ASIN1',
#         'ASIN2',
#         'ASIN3',
#         ...
#         'ASIN10'
#       ]
#     },
#     {
#       :product_attributes => {
#         small_image: ''
#         medium_image: ''
#         large_image: ''
#         title: ''
#         price: ''
#         brand: ''
#         buylink: ''
#       }
#       :similar_products   => [
#         'ASIN1',
#         'ASIN2',
#         'ASIN3',
#         ...
#         'ASIN10'
#       ]
#     },
#     ...
#   ]
#
# get_ten_asins returns an array of ten random ASINs

module ProductLookup
  # make instance methods available as class methods
  extend self

  def load_from_asin asin
    req = ProductLookup.get_request_object

    params = {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ResponseGroup' => "Large",
      'ItemId'        => asin
    }

    res = Response.new(req.get(query: params)).to_h
    item_response = res["ItemLookupResponse"]["Items"]["Item"]

    {
      product_attributes: get_attribute_hash(item_response),
      similar_products: get_similar_products(item_response)
    }
  end

  def get_request_object
    req = Vacuum.new('US')
    req.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] ,
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['ASSOCIATE_TAG']
      )
  end

  def get_attribute_hash item_response
    {
      small_image: item_response["SmallImage"]["URL"],
      medium_image: item_response["MediumImage"]["URL"],
      large_image: item_response["LargeImage"]["URL"],
      title: item_response["ItemAttributes"]["Title"],
      # price: item_response["ItemAttributes"]["ListPrice"]["FormattedPrice"], ***need to account for products without prices
      brand: item_response["ItemAttributes"]["Brand"],
      buylink: item_response["DetailPageURL"]
    }
  end

  def get_similar_products item_response
    similar_product_array = item_response["SimilarProducts"]["SimilarProduct"]
    similar_product_asins = similar_product_array.map {|product| product["ASIN"]}
  end

  def get_ten_asins
    req = ProductLookup.get_request_object
    params = {
      'Operation'     => 'ItemSearch',
      'SearchIndex'   => 'Apparel',
      'ResponseGroup' => 'ItemAttributes',
      'Keywords'      => 'Calvin Klein'
    }
    res = Response.new(req.get(query: params)).to_h
    item_response = res["ItemSearchResponse"]["Items"]["Item"]
    item_response.map { |product| product["ASIN"]}
  end
end


if $0 == __FILE__
end

