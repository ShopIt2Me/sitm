require 'spec_helper'

describe SessionsController do

  describe "set_pref_dept" do
    it "should set preferred_dept of Session to correct department" do
      simple_session = FactoryGirl.create(:simple_session)
      post :set_pref_dept, preferred_dept: 'mens', session_key: 'test'
      expect(SimpleSession.find_by(session_key: 'test')[:value][:preferred_dept]).to eq("mens")
    end
  end
end

