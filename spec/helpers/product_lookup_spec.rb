require 'spec_helper'

describe 'ProductLookup' do

  it "load_product_batch returns an array of product attributes" do
    expect(ProductLookup.load_product_batch("B00DQN7NA8,B00CHHCCDC")).to be_a(Array)
  end

  it "load_product_batch returns an array of product attributes even when it has only one product" do
    expect(ProductLookup.load_product_batch("B00DQN7NA8")).to be_a(Array)
  end

end
