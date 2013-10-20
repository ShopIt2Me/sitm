require 'spec_helper'

describe ProductsController do
  let (:prod1_attrs) { {asin: 'B00CTGB8OK', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', department: 'mens', asins_of_sim_prods: "B00CTGB4M6,B00CTGB4OO,B00CTGB5FW,B00CTGB2X2,B00CTGB1Y2"}}

  context "when a user likes a product"
  it "for the first time, should add array of product id in the session value" do 
    prod1 = Product.create(prod1_attrs)
    SimpleSession.create(session_key: 'test')
    post :like, product_id: prod1.id, session_key: 'test'

    expect(SimpleSession.last.value[:ary_of_likes]).to eq ([prod1.id])
  end
  
  it "should add liked product id to array of liked product ids in session value" do
    prod1 = Product.create(prod1_attrs)
    SimpleSession.create(session_key: 'test', value: {ary_of_likes: [1]})
    post :like, product_id: prod1.id, session_key: 'test'
    
    expect(SimpleSession.last.value[:ary_of_likes]).to eq ([1, prod1.id])
  end

end
