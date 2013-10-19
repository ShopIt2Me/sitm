# This module will take tuples of product ids and its similar product ASINs
# as an array of strings.
#
# Then, it sends batches of products to query Amazon by the ProductLookup module
# for its attributes. Once the attributes are retrieved, the products and the 
# similarities are saved into the database.
# 
# The priority of the batches are defined by how many entries each similar 
# product has.
# 


module ProductPrioritySet
  # make instance methods available as class methods
  extend self

  MAX_AMAZON_BATCH_SIZE = 10

  def add_to_set(product_id, asins)
    asins.each do |asin|
      ProductPriority.create(product_id: product_id, asin: asin)
    end
  end

  def send_next_batch
    products = ProductLookup.load_product_batch(self.next_batch)
    handle_new_products(products)
  end

  def next_batch
    batch_hash = ProductPriority.count(
      :group => :asin,
      :order => 'count_all DESC',
      :limit => MAX_AMAZON_BATCH_SIZE
    )
    batch_hash.keys.join(',')
  end

  def handle_new_products(products)
    persist_products(products)
    delete_persisted_product_priorities(products)
  end

  def persist_products(products)
    products.each do |product_attributes|
      product_priority_entries = ProductPriority.where('asin = ?', product_attributes.asin).uniq_by(&:product_id)

      product_priority_entries.each do |product_priority_entry|
        parent_product = Product.find(product_priority_entry.id)
        parent_product.similarprods.create(product_attributes)
      end
    end
  end

  def delete_persisted_product_priorities(products)
    products.each do |product|
      ProductPriority.destroy_all(asin: product[:asin])
    end
  end
end

if $0 == __FILE__
  require_relative './product_lookup'

  ap ProductPrioritySet.next_batch
end







