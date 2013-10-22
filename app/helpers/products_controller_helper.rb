module ProductsControllerHelper

  def get_top_prods(preferred_dept, top_prods, num_random_products)
    if preferred_dept == "both"
      top_prods << Product.where('id NOT IN (?)', @simple_session.ary_of_displayed_ids).sample(num_random_products)
      return top_prods.flatten!
    else
      top_prods << Product.where('id NOT IN (?) AND department = ?', @simple_session.ary_of_displayed_ids, preferred_dept).sample(num_random_products)
      return top_prods.flatten!
    end
  end

end
