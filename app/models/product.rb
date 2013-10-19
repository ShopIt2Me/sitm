class Product < ActiveRecord::Base
  has_many :images

  has_many :similars
  has_many :similarprods, :through => :similars


  validates_presence_of :asin, :buylink, :large_image, :medium_image, :small_image
  validates_uniqueness_of :asin
end



