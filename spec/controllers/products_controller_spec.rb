require 'spec_helper'

describe ProductsController do
  before(:each) do
    session[:session_id] = 'test596'
  end
  after(:each) do
    SimpleSession.last.destroy
  end


  render_views
  let (:prod1) { FactoryGirl.create(:product, asin: 'B00CTGB8OK', asins_of_sim_prods: "B00CTGB4M6,B00CTGU4M7") }
  let (:prod2) { FactoryGirl.create(:product, asin: 'B00CTGB4M6') }
  let (:prod3) { FactoryGirl.create(:product, asin: 'B00CTGU4M7') }

  let (:simple_session) { FactoryGirl.create(:simple_session, { session_key: session[:session_id], value: {ary_of_likes: [], ary_of_displayed_ids: [], preferred_dept: "both" } }) }

  context "when a user likes a product" do
    it "should add liked product id to array of liked product ids in session value" do
      post :like, product_id: prod1.id

      expect(SimpleSession.last.ary_of_likes).to eq([prod1.id])
    end
  end

  context "when a user loads more products" do
    it "should determine the next batch of products to display based on likes" do
      prod1.similarprods << [prod2, prod3]
      simple_session.update_liked_ids(prod1.id)

      get :load

      expect(response.body).to match(Regexp.new(prod1.title + "(.*)?" + prod2.title, Regexp::MULTILINE))
    end

    it "should update the array of already displayed product ids for the session" do
      prod1.similarprods << [prod2, prod3]
      simple_session.update_liked_ids(prod1.id)

      get :load

      expect(SimpleSession.last.ary_of_displayed_ids).to eq([prod2.id, prod3.id])
    end

    it "should display five additional unique random products if no products on page were liked" do
      20.times do |n|
        FactoryGirl.create(:product, asin: (n+10).to_s )
      end

      simple_session.update_displayed_ids([1])
      simple_session.save
      get :load, fill_with_random: true

      expect(SimpleSession.last.ary_of_displayed_ids.length).to eq(6)
    end

    it "does not return any products if no products on page were liked" do
      20.times do |n|
        FactoryGirl.create(:product, asin: (n+10).to_s )
      end

      simple_session.update_displayed_ids([1])
      simple_session.save
      get :load
      expect(SimpleSession.last.ary_of_displayed_ids.length).to eq(1)
    end

    it "loads women's products when user specifies preferred department as women's" do
      new_session = FactoryGirl.create(:simple_session, { session_key: session[:session_id], value: {ary_of_likes: [], ary_of_displayed_ids: [1], preferred_dept:"womens" } })
      FactoryGirl.create(:product, department: "womens", id: 1000)
      get :load, fill_with_random: true
      expect(SimpleSession.last.ary_of_displayed_ids.length).to eq(2)
    end

    it "loads both gender's products when user specifies preferred department as 'both'" do
      new_session = FactoryGirl.create(:simple_session, { session_key: session[:session_id], value: {ary_of_likes: [], ary_of_displayed_ids: [1], preferred_dept:"both" } })
      FactoryGirl.create(:product, department: "womens", id: 1000)
      get :load, fill_with_random: true
      expect(SimpleSession.last.ary_of_displayed_ids.length).to eq(2)
    end

    it "loads men's products when user specifies preferred department as men's" do
      new_session = FactoryGirl.create(:simple_session, { session_key: session[:session_id], value: {ary_of_likes: [], ary_of_displayed_ids: [1], preferred_dept:"mens" } })
      FactoryGirl.create(:product, department: "mens", id: 1000)
      get :load, fill_with_random: true
      expect(SimpleSession.last.ary_of_displayed_ids.length).to eq(2)
    end
  end
end
