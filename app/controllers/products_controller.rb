class ProductsController < ApplicationController
  def index
  	@products = Product.all.shuffle.shift(20)
  end


  def load
    freq_hash = DisplayPrioritizer.frequentize(@simple_session.ary_of_likes, @simple_session.ary_of_displayed_ids)
    top_ten_prod_ids = DisplayPrioritizer.top_prod_ids(freq_hash, 10)
    top_prods = DisplayPrioritizer.get_top_prods(top_ten_prod_ids)

    @simple_session.update_displayed_ids(top_ten_prod_ids)

    render partial: "products/product_list", locals: { products: top_prods }
  end 

  def like
    product_id = params[:product_id].to_i
    missing = Product.find(product_id).identify_missing_asins
    # ProductPrioritySet.add_to_set(product_id, missing) UNTIL MERGED
    @simple_session.update_liked_ids(product_id)
    render :json => "Success".to_json
  end


end

