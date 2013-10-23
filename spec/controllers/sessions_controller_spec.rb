require 'spec_helper'

describe SessionsController do
  before(:each) do
    session[:session_id] = 'test596'
  end
  after(:each) do
    SimpleSession.last.destroy
  end

  let (:simple_session) { FactoryGirl.create(:simple_session, { session_key: session[:session_id], value: {ary_of_likes: [], ary_of_displayed_ids: [], preferred_dept: "both" } }) }


  describe "set_pref_dept" do
    it "should set preferred_dept of Session to correct department" do
      simple_session
      post :set_pref_dept, preferred_dept: 'mens'
      expect(SimpleSession.last[:value][:preferred_dept]).to eq("mens")
    end
  end
end

