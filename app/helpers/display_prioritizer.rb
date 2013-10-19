#DisplayPrioritizer is responsible for providing the UI with the next 10 products to display on the page. 
  # First will retrieve similar product ids to liked products from database.
  # Then will filter out already displayed products
  # Then will prioritize based on frequency of sim products
  # Then choose top 10 products and retrieve product info from database
  # Transmit products in JSON format to UI

# #Inputs:
#   -Array of already displayed products
#   -Array of liked products

# #Outputs:
#   -JSON object of 10 products

module DisplayPrioritizer
  extend self

  def frequentize(ary_of_likes_ids, ary_of_displayed_ids)
    freq_hash = {}
    ary_of_likes_ids.each do |liked_id|
      sim_product_ids = get_sim_prod_ids(liked_id)
      never_displayed_ids = sim_product_ids - ary_of_displayed_ids
      freq_hash = update_freq_hash(freq_hash, never_displayed_ids)
    end
    freq_hash
  end

  def get_sim_prod_ids(liked_id)
    prod = Product.find(liked_id)
    prod.similarprods.map { |prod| prod.id }
  end

  def update_freq_hash(freq_hash, never_displayed_ids)
    never_displayed_ids.each do |prod_id|
      freq_hash[prod_id] == nil ? freq_hash[prod_id] = 1 : freq_hash[prod_id] += 1
    end
    freq_hash
  end
end


if $0 == __FILE__

  require_relative '../../config/environment'

  p DisplayPrioritizer.frequentize([7,1], [5])
end
