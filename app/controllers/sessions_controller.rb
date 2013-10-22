class SessionsController < ApplicationController

  def set_pref_dept
    @simple_session[:value][:preferred_dept] = params[:preferred_dept]
    @simple_session.save
    render :json => "Success".to_json  
  end

end
