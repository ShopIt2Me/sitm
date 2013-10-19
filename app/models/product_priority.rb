class ProductPriority < ActiveRecord::Base
  validates_uniqueness_of :product_id, :scope => :asin
end
