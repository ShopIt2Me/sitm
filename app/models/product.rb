class Product < ActiveRecord::Base
  has_many :images
  validates_presence_of :amzn_id, :buylink, :large_image, :medium_image, :small_image
  validates_uniqueness_of :amzn_id

end
