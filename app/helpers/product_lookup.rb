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
#       department: ''
#       price: ''
#       brand: ''
#       buylink: ''
#       asins_of_sim_prods: 'ASIN1,ASIN2,ASIN3,...,ASIN10'
#     },
#     ...
#   ]
#
# get_ten_asins returns an array of ten random ASINs

module ProductLookup
  # make instance methods available as class methods
  extend self

  def load_product_batch asins
    res = get_parsed_response(get_params(asins))

    if is_valid_response?(res)
      items = res["ItemLookupResponse"]["Items"]["Item"]
      return normalize_response(items)
    end

    []
  end

  def get_params asins
    {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ResponseGroup' => 'Large',
      'ItemId'        => asins
    }
  end

  def get_parsed_response(params)
    req = ProductLookup.get_request_object
    Response.new(req.get(query: params)).to_h
  end

  def normalize_response(item_response)
    [item_response].flatten.map { |item| get_attribute_hash(item) }.compact
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
    begin
      {
        asin: item_response["ASIN"],
        small_image: item_response["SmallImage"]["URL"],
        medium_image: item_response["MediumImage"]["URL"],
        large_image: item_response["LargeImage"]["URL"],
        title: item_response["ItemAttributes"]["Title"],
        department: item_response["ItemAttributes"]["Department"],
        price: item_response["ItemAttributes"]["ListPrice"] ? item_response["ItemAttributes"]["ListPrice"]["FormattedPrice"] : '-',
        brand: item_response["ItemAttributes"]["Brand"],
        buylink: item_response["DetailPageURL"],
        asins_of_sim_prods: get_similar_products(item_response).join(",")
      }
    rescue
      nil
    end
  end

  def get_similar_products item_response
    return [] if item_response["SimilarProducts"].nil?
    similar_product = item_response["SimilarProducts"]["SimilarProduct"]
    [similar_product].flatten.map { |product| product["ASIN"] }
  end

  def get_ten_asins(gender = '', page = '', keywords = '', brand = '')
    department = '1040658' if gender == 'mens'
    department = '1040660' if gender == 'womens'
    page = _get_random_page if page.empty?
    brand = _get_random_brand if brand.empty?
    req = ProductLookup.get_request_object
    params = {
      'Operation'     => 'ItemSearch',
      'SearchIndex'   => 'Apparel',
      'ResponseGroup' => 'ItemAttributes',
      'Brand'         =>  brand,
      'Sort'          => 'salesrank',
      'BrowseNode'    =>  department,
      'Keywords'      =>  keywords,
      'ItemPage'      =>  page
    }
    res = Response.new(req.get(query: params)).to_h
    return nil if res["ItemSearchResponse"]["Items"]["Request"]["Errors"]
    item_response = normalize_to_array(res["ItemSearchResponse"]["Items"]["Item"])
    item_response.map { |product| product["ASIN"]}
  end

  def normalize_to_array(item_search_response)
    [item_search_response].flatten
  end

  def _get_random_page
    rand(1..3).to_s
  end


  def _get_random_brand
    'Ben Sherman,Cheap Monday,Ella Moss,Helmut Lang,MANGO,Rock and Republic,Scotch and Soda,Vivienne Westwood,Young and Reckless,RVCA,Funktional,Zachary Prell,Rag and Bone,Free People,G-Star,Naked and Famous,Jack Spade,Pendleton,Vince'.split(',').sample
  end
end


if $0 == __FILE__
  require 'vacuum'
  require 'awesome_print'
  require_relative '../../config/environment'

  ProductLookup.load_product_batch("B00CHHCCDC,B00CHHBDQE,B00DH9OSWM,B00CHHBDA0,B00CHHBDAU,B00CHHB2QU,B00CHHB2T2,B00DH9NB52,B00DP34DW0")
  # ProductLookup.get_ten_asins
  # ProductLookup.load_product_batch("B00DQN7NA8")
  # ap ProductLookup.load_product_batch("B00CHHB2QU")
end
