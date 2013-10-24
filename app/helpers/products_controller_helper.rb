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

  def handle_randomized_times_result_session(params)
    if params[:fill_with_random]
      @simple_session[:value][:randomized_times] = rand(6..10)
      @simple_session.save
    end

    if @simple_session[:value][:randomized_times].to_i > 0
      @simple_session[:value][:randomized_times] -= 1
      @simple_session.save
    end
  end

end
