class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_session

  def update_session

    @simple_session = SimpleSession.find_by session_key: session[:session_id]
    unless @simple_session
      @simple_session = SimpleSession.create(session_key: session[:session_id], value: {ary_of_likes: [], ary_of_displayed_ids:[], preferred_dept: 'both'})
    end
  end

end
