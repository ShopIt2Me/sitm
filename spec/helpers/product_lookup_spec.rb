require 'spec_helper'

describe 'ProductLookup' do

  it "load_product_batch returns an array of product attributes" do
    expect(ProductLookup.load_product_batch("B00DQN7NA8,B00CHHCCDC")).to be_a(Array)
  end

  it "load_product_batch returns an array of product attributes even when it has only one product" do
    expect(ProductLookup.load_product_batch("B00DQN7NA8")).to be_a(Array)
  end

  it "get_attribute_hash returns nil if query response is missing a required attribute" do
    expect(ProductLookup.get_attribute_hash({ :bad_response => 123 })).to be(nil)
  end

  it "load_product_batch ignores malformed product responses" do
    ProductLookup.stub(:get_parsed_response) {
      params = ProductLookup.get_params("B00DQN7NA8,B00CHHCCDC")
      req = ProductLookup.get_request_object
      res = Response.new(req.get(query: params)).to_h

      res["ItemLookupResponse"]["Items"]["Item"][0]['ItemAttributes'] = nil
      res
    }

    expect(ProductLookup.load_product_batch("B00DQN7NA8,B00CHHCCDC").length).to be(1)
  end

end
