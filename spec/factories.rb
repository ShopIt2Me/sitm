FactoryGirl.define do

  factory :product_priority do
    product_id { 1 }
    asin  { "B00CHHCCDC" }
  end  

  factory :product do
    asin {"B00CHHCCDC"}
    small_image {"http://www.example.com/small.jpg"}
    medium_image {"http://www.example.com/med.jpg"}
    large_image {"http://www.example.com/large.jpg"}
    title {"American Apparel Hoodie!!"}
    price {"$25.99"}
    brand {"American Apparel"}
    buylink {"http://www.amazon.com/example_link"}
    asins_of_sim_prods {"B00CHHCCDC,B00CHHBDQE,B00DH9OSWM,B00CHHBDA0,B00CHHBDAU,B00CHHB2QU,B00CHHB2T2,B00DH9NB52"}
  end

  factory :product_hash, class:Hash do
    asin "B00CHHCCDC"
    small_image "http://www.example.com/small.jpg"
    medium_image "http://www.example.com/med.jpg"
    large_image "http://www.example.com/large.jpg"
    title "American Apparel Hoodie!!"
    price "$25.99"
    brand "American Apparel"
    buylink "http://www.amazon.com/example_link"
    asins_of_sim_prods "B00CHHCCDC,B00CHHBDQE,B00DH9OSWM,B00CHHBDA0,B00CHHBDAU,B00CHHB2QU,B00CHHB2T2,B00DH9NB52"

    initialize_with { attributes } 
  end

end
