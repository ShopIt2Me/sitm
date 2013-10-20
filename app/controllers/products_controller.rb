class ProductsController < ApplicationController
  def index
  	@products = Product.all.limit(10)
  end

  def load
    # go to session and retrieve array of likes and array of already displayed products
    # call Display Prioritizer and pass in the array of likes and array of already displayed
    # pass JSON to view
    # update already displayed products in sessions
  end 
end
