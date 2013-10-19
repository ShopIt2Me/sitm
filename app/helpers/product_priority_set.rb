# This module will take tuples of product ids and its similar products ASINs
# as an array of strings.
#
# Then, it sends batches of products to query Amazon by the ProductLookup module
# for its attributes. Once the attributes are retrieved, the products and the 
# similarities are saved into the Database.
# 
# The Priority of the batches are defined by how many entries each similar 
# product has.
# 


module ProductPrioritySet
  # make instance methods available as class methods
  extend self

  def add_to_set(product_id, asins)
    asins.each do |asin|
      ProductPriority.create(product_id: product_id, asin: asin)
    end
  end

end
