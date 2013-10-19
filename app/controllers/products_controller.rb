class ProductsController < ApplicationController
  def index
  	@products = Product.all.limit(10)
  end

  def like
    missing = Product.find(params[:product_id]).identify_missing_asins
    ProductPrioritySet.add_to_set(params[:product_id], missing)
  end
end
