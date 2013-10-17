class Product < ActiveRecord::Base
  has_many :images
  validates_prescence_of :amzn_id, :buylink, :image
  validates_uniqueness_of :amzn_id
end
