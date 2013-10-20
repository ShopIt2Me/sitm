class ProductsController < ApplicationController
  def index
  	@products = Product.all.shuffle
  end

  def like
    product_id = params[:product_id]
    missing = Product.find(product_id).identify_missing_asins
    ProductPrioritySet.add_to_set(product_id, missing)
    if @simple_session.value[:ary_of_likes] 
      @simple_session.value[:ary_of_likes] << product_id.to_i 
    else
      @simple_session.value[:ary_of_likes] = [product_id.to_i]
    end
    @simple_session.save
    render :index
  end

end
