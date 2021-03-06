class Product < ActiveRecord::Base
  has_many :images

  has_many :similars
  has_many :similarprods, :through => :similars


  validates_presence_of :asin, :buylink, :large_image, :medium_image, :small_image, :department
  validates_uniqueness_of :asin
  validates_inclusion_of :department, :in => ["mens", "womens"]

  def get_asins_ary
    self.asins_of_sim_prods.split(",")
  end


  def identify_missing_asins
    missing = []
    self.get_asins_ary.each do |asin|
      product = Product.find_by asin: asin
      missing << asin unless product
    end
    missing
  end

  def title_mini
    if self.title.match(/.{45}[^\s\b]+/).to_s.empty?
      self.title
    else
      self.title.match(/.{45,50}[^\s\b]+/).to_s
    end
  end
end



