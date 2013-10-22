require 'spec_helper'

describe ProductsController do
  render_views
  let (:prod1) { FactoryGirl.create(:product, asin: 'B00CTGB8OK', asins_of_sim_prods: "B00CTGB4M6,B00CTGU4M7") }
  let (:prod2) { FactoryGirl.create(:product, asin: 'B00CTGB4M6') }
  let (:prod3) { FactoryGirl.create(:product, asin: 'B00CTGU4M7') }

  let (:simple_session) { FactoryGirl.create(:simple_session, { session_key: 'test' + rand(1..500).to_s, value: {ary_of_likes: [], ary_of_displayed_ids: [1,2,5], preferred_dept: "both" } }) }

  context "when a user likes a product"
  it "should add liked product id to array of liked product ids in session value" do
    simple_session
    post :like, product_id: prod1.id, session_key: 'test'

    expect(SimpleSession.last.ary_of_likes).to eq([prod1.id])
  end

  context "when a user loads more products" do

    it "should determine the next batch of products to display based on likes" do
      prod1.similarprods << [prod2, prod3]

      simple_session.update_liked_ids(prod1.id)

      get :load, session_key: simple_session.session_key

      expect(response.body).to match(Regexp.new(prod1.title + "(.*)?" + prod2.title, Regexp::MULTILINE))
    end

    it "should update the array of already displayed product ids for the session" do
      simple_session = FactoryGirl.create(:simple_session, { value: {ary_of_likes: [], ary_of_displayed_ids: [], preferred_dept: "both" } })

      prod1.similarprods << [prod2, prod3]
      simple_session.update_liked_ids(prod1.id)

      get :load, session_key: simple_session.session_key

      expect(SimpleSession.last.ary_of_displayed_ids).to eq([prod2.id, prod3.id])
    end

    it "should display ten unique random products if no products on page were liked" do
      20.times do |n|
        FactoryGirl.create(:product, asin: (n+10).to_s )
      end

      get :load, session_key: simple_session.session_key, fill_with_random: true
      expect(SimpleSession.find_by(session_key: simple_session.session_key).ary_of_displayed_ids.length).to eq(8)
    end

    it "does not return any products if no products on page were liked" do
      20.times do |n|
        FactoryGirl.create(:product, asin: (n+10).to_s )
      end

      get :load, session_key: simple_session.session_key
      expect(SimpleSession.find_by(session_key: simple_session.session_key).ary_of_displayed_ids.length).to eq(3)
    end

    it "loads women's products when user specifies preferred department as women's" do
      new_session = FactoryGirl.create(:simple_session, { session_key: 'test' + rand(1..500).to_s, value: {ary_of_likes: [], ary_of_displayed_ids: [1], preferred_dept:"womens" } })
      FactoryGirl.create(:product, department: "womens", id: 1000)
      get :load, fill_with_random: true, session_key: new_session.session_key
      expect(SimpleSession.find_by(session_key: new_session.session_key).ary_of_displayed_ids.length).to eq(2)
    end

    it "loads both gender's products when user specifies preferred department as 'both'" do
      new_session = FactoryGirl.create(:simple_session, { session_key: 'test' + rand(1..500).to_s, value: {ary_of_likes: [], ary_of_displayed_ids: [1], preferred_dept:"both" } })
      FactoryGirl.create(:product, department: "womens", id: 1000)
      get :load, fill_with_random: true, session_key: new_session.session_key
      expect(SimpleSession.find_by(session_key: new_session.session_key).ary_of_displayed_ids.length).to eq(2)
    end

    it "loads men's products when user specifies preferred department as men's" do
      new_session = FactoryGirl.create(:simple_session, { session_key: 'test' + rand(1..500).to_s, value: {ary_of_likes: [], ary_of_displayed_ids: [1], preferred_dept:"mens" } })
      FactoryGirl.create(:product, department: "mens", id: 1000)
      get :load, fill_with_random: true, session_key: new_session.session_key
      expect(SimpleSession.find_by(session_key: new_session.session_key).ary_of_displayed_ids.length).to eq(2)
    end
  end
end
