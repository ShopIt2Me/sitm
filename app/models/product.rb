class Product < ActiveRecord::Base
  has_many :images
  validates_prescence_of :amzn_id, :buylink, :image
end
