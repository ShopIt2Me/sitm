require 'spec_helper'

describe ProductsController do
  let (:prod1) { Product.create(asin: 'B00CTGB8OK', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', asins_of_sim_prods: "B00CTGB4M6,B00CTGU4M7", department: 'mens' )}
  let (:prod2) { Product.create(asin: 'B00CTGB4M6', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', asins_of_sim_prods: "", department: 'mens')}
  let (:prod3) { Product.create(asin: 'B00CTGU4M7', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', asins_of_sim_prods: "", department: 'mens')}
  let (:simple_session) { SimpleSession.create(session_key: 'test', value: {ary_of_likes: [], ary_of_displayed_ids: []})}

  context "when a user likes a product"
    it "should add liked product id to array of liked product ids in session value" do
      prod1
      simple_session
      post :like, product_id: prod1.id, session_key: 'test'

      expect(SimpleSession.last.ary_of_likes).to eq ([prod1.id])
    end

  context "when a user loads more products" do

    it "should determine the next batch of products to display based on likes" do
      prod1.similarprods << [prod2, prod3]

      simple_session.update_liked_ids(prod1.id)

      get :load, :format => :json, session_key: 'test'
      expect(response.body). to include([prod2, prod3].to_json)

    end

    it "should update the array of already displayed product ids for the session" do
      prod1.similarprods << [prod2, prod3]
      simple_session.update_liked_ids(prod1.id)

      get :load, { :format => :json, session_key: 'test'}

      expect(SimpleSession.last.ary_of_displayed_ids).to eq ([prod2.id, prod3.id])
    end
  end
end
