class ProductsController < ApplicationController
  TOTAL_PRODUCTS_RETURNED = 10

  def index
  	@products = Product.all.shuffle.shift(20)
    @simple_session.update_displayed_ids(@products)
  end


  def load
    freq_hash = DisplayPrioritizer.frequentize(@simple_session.ary_of_likes, @simple_session.ary_of_displayed_ids)
    top_ten_prod_ids = DisplayPrioritizer.top_prod_ids(freq_hash, TOTAL_PRODUCTS_RETURNED)
    top_prods = DisplayPrioritizer.get_top_prods(top_ten_prod_ids)

    num_random_products = TOTAL_PRODUCTS_RETURNED - top_prods.length

    top_prods << Product.where('id NOT IN (?)', @simple_session.ary_of_displayed_ids).sample(num_random_products)
    top_prods.flatten!

    @simple_session.update_displayed_ids(top_prods)
    render partial: "products/product_list", locals: { products: top_prods }
  end 

  def like
    product_id = params[:product_id].to_i
    missing = Product.find(product_id).identify_missing_asins
    ProductPrioritySet.add_to_set(product_id, missing)
    @simple_session.update_liked_ids(product_id)
    render :json => "Success".to_json
  end

end
