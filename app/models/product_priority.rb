class ProductPriority < ActiveRecord::Base
  validates_presence_of :asin
  validates_presence_of :product_id
end
