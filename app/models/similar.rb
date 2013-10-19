class Similar < ActiveRecord::Base
  belongs_to :product
  belongs_to :similarprod, :class_name => "Product"
end
