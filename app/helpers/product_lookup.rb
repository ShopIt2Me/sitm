# ProductLookup module takes care of querying Amazon API for products
#
# load_product_batch method receives batches of Amazon ASINS in the format of:
#   FORMAT: String => "ASIN1,ASIN2,ASIN3,..,ASIN10"
#
# And returns and array containing a hash for each product composed by
# the product attributes and its similar products, in the format of:
#   FORMAT: Array => [
#     {
#       small_image: ''
#       medium_image: ''
#       large_image: ''
#       title: ''
#       price: ''
#       brand: ''
#       buylink: ''
#       sim_products: 'ASIN1,ASIN2,ASIN3,...,ASIN10'
#     },
#     ...
#   ]
#
# get_ten_asins returns an array of ten random ASINs

module ProductLookup
  # make instance methods available as class methods
  extend self

  def load_product_batch asins
    req = ProductLookup.get_request_object

    params = {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ResponseGroup' => 'Large',
      'ItemId'        => asins
    }

    res = Response.new(req.get(query: params)).to_h
    ap res["ItemLookupResponse"]["Items"]["Request"]["IsValid"]
    if is_valid_response?(res)
      items = res["ItemLookupResponse"]["Items"]["Item"]
      if items.is_a?(Hash)
        return [get_attribute_hash(items)]
      else
        return items.map { |item| get_attribute_hash(item) }
      end
    end

    []
  end

  def is_valid_response?(response)
    response["ItemLookupResponse"]["Items"]["Request"]["IsValid"] == "True"
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
      asin: item_response["ASIN"],
      small_image: item_response["SmallImage"]["URL"],
      medium_image: item_response["MediumImage"]["URL"],
      large_image: item_response["LargeImage"]["URL"],
      title: item_response["ItemAttributes"]["Title"],
      price: item_response["ItemAttributes"]["ListPrice"] ? item_response["ItemAttributes"]["ListPrice"]["FormattedPrice"] : '-',
      brand: item_response["ItemAttributes"]["Brand"],
      buylink: item_response["DetailPageURL"],
      asins_of_sim_prods: get_similar_products(item_response).join(",")
    }
  end

  def get_similar_products item_response
    similar_product = item_response["SimilarProducts"]["SimilarProduct"]
    if similar_product.is_a?(Hash)
      [similar_product['ASIN']]
    else
      similar_product.map { |product| product["ASIN"] }
    end
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
  require 'vacuum'
  require 'awesome_print'
  require_relative '../../config/environment'

  ProductLookup.load_product_batch("B00CHHCCDC,B00CHHBDQE,B00DH9OSWM,B00CHHBDA0,B00CHHBDAU,B00CHHB2QU,B00CHHB2T2,B00DH9NB52,B00DP34DW0")
  # ap ProductLookup.load_product_batch("B00DQN7NA8")
  # ap ProductLookup.load_product_batch("B00CHHB2QU")
end
