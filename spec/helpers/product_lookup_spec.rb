require 'spec_helper'

describe 'ProductLookup' do

  before(:each) do
    @product_lookup = double()
    @product_lookup.stub(:get_ten_asins) {[
      "B00E8INIEA",
      "B00DPGBSFM",
      "B00DU6A3N0",
      "B00DQN7KTW",
      "B00DPGBSIE",
      "B00DQN7KS8",
      "B00CHHBEPE",
      "B00DUTZY1I",
      "B00CQMGH0M",
      "B00CTGB8OK"
    ]}
  end

  it "get_ten_asins return tens asins" do
    expect(@product_lookup.get_ten_asins.length).to be(10)
  end

  it "load_product_batch accepts a string of ASINs separeted by commas" do
    # expect(ProductLookup.load_product_batch(ten_asins.join(',')).length).to be(10)
  end
end
