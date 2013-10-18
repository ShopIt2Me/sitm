class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_session

  def update_session 
    unless params[:session]
      params[:session] = {:session_key => generate_session_key, :value => nil}
    end
    @simple_session = SimpleSession.find_by_session_key(params[:session_key])
    unless @simple_session
      @simple_session = SimpleSession.create(session_key: params[:session][:session_key], value: params[:session][:value])
    end

  end

end
