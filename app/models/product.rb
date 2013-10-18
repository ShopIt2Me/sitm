class Product < ActiveRecord::Base
  has_many :images
  validates_presence_of :amzn_id, :buylink, :image
  validates_uniqueness_of :amzn_id
end
