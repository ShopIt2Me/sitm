class SimpleSession < ActiveRecord::Base
	validates_presence_of :session_key
  validates_uniqueness_of :session_key

  serialize :value, Hash

  def ary_of_likes 
    self.value[:ary_of_likes]
  end

  def ary_of_displayed_ids
    self.value[:ary_of_displayed_ids]
  end

  def update_displayed_ids(ary_of_loaded_prods)
    product_ids = ary_of_loaded_prods.map { |el| el.is_a?(Fixnum) ? el : el.id }
    self.ary_of_displayed_ids << product_ids
    self.ary_of_displayed_ids.flatten!
    self.save
  end

  def update_liked_ids(liked_prod_id)
    self.ary_of_likes << liked_prod_id
    self.save
  end
end
