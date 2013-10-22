class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_session

  def update_session
    unless params[:session_key]
      params[:session_key] = generate_session_key
    end
      @simple_session = SimpleSession.find_by session_key: params[:session_key]
    unless @simple_session
      @simple_session = SimpleSession.create(session_key: params[:session_key], value: {ary_of_likes: [], ary_of_displayed_ids:[], preferred_dept: 'both'})
    end
  end

end
