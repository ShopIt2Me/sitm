class ProductsController < ApplicationController
  def index
  	@products = Product.all.shuffle
  end
end
