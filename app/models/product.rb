class Product < ActiveRecord::Base
  has_many :images

  validates_presence_of :asin, :buylink, :large_image, :medium_image, :small_image
  validates_uniqueness_of :asin
end



