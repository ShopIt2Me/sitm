require 'spec_helper'

describe DisplayPrioritizer do

  let (:prod1) { Product.create(asin: 'B00CTGB8OK', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', asins_of_sim_prods: "B00CTGB4M6,B00CTGB4OO,B00CTGB5FW,B00CTGB2X2,B00CTGB1Y2")}
  let (:prod2) { Product.create(asin: 'B00CTGB4M6', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', asins_of_sim_prods: "B00CTGB4OO,B00CTGB5FW,B00CTGB2X2,B00CTGB1Y2")}
  let (:prod3) { Product.create(asin: 'B00CTGU4M7', buylink: 'link', large_image: 'l_image', medium_image: 'm_image', small_image: 's_image', asins_of_sim_prods: "B00CTGB4OO,B00CTGB5FW,B00CTGB2X2,B00CTGB1Y2")}
  

  it "should return an array of product ids for similar products in the db given a product id" do
    prod1.similarprods << prod2
    prod1.similarprods << prod3
    prod1.save

    expect(DisplayPrioritizer.get_sim_prod_ids(prod1.id)).to eq ([prod2.id, prod3.id])    
  end 

  it "create a hash that tallies the number of times a product id is a similar product" do
    prod1.similarprods << prod2
    prod1.similarprods << prod3
    prod1.save

    prod2.similarprods << prod1
    prod2.similarprods << prod3
    prod2.save

    expect(DisplayPrioritizer.frequentize([prod1.id, prod2.id],[])).to eq ({prod3.id => 2, prod1.id => 1, prod2.id => 1})

  end
  
  it "should remove the product ids of products that have already been displayed on the page" do
    prod1.similarprods << prod2
    prod1.similarprods << prod3
    prod1.save

    prod2.similarprods << prod1
    prod2.similarprods << prod3
    prod2.save

    expect(DisplayPrioritizer.frequentize([prod1.id, prod2.id],[prod1.id,prod2.id])).to eq ({prod3.id => 2})
  end


end
