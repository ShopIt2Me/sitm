class ProductsController < ApplicationController
  def index
  	@products = Product.all#.limit(10)
  end
end
