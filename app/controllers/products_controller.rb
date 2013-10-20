class ProductsController < ApplicationController
  def index
  	@products = Product.all.limit(10)
  end


  def load
    session = @simple_session.value
    session[:ary_of_likes] ? ary_of_likes = session[:ary_of_likes] : ary_of_likes = []
    session[:ary_of_displayed_ids] ? ary_of_displayed_ids = session[:ary_of_displayed_ids] : ary_of_displayed_ids = []

    freq_hash = DisplayPrioritizer.frequentize(ary_of_likes, ary_of_displayed_ids)
    top_ten_prod_ids = DisplayPrioritizer.top_prod_ids(freq_hash, 10)
    top_prods = DisplayPrioritizer.get_top_prods(top_ten_prod_ids)

    ary_of_displayed_ids << top_ten_prod_ids
    ary_of_displayed_ids.flatten!
    @simple_session.value[:ary_of_displayed_ids] = ary_of_displayed_ids
    @simple_session.save

    render json: top_prods.to_json
  end 

  def like
    product_id = params[:product_id]
    missing = Product.find(product_id).identify_missing_asins
    # ProductPrioritySet.add_to_set(product_id, missing) UNTIL MERGED
    if @simple_session.value[:ary_of_likes] 
      @simple_session.value[:ary_of_likes] << product_id.to_i 
    else
      @simple_session.value[:ary_of_likes] = [product_id.to_i]
    end
    @simple_session.save
    render :index
  end


end
