require 'spec_helper'

describe 'ProductPrioritySet' do

  describe "add_to_set" do
    it "creates product priority objects" do
      product_id = 1
      asins = ["B00CHHCCDC","B00CHHBDQE","B00DH9OSWM","B00CHHBDA0","B00CHHBDAU","B00CHHB2QU","B00CHHB2T2","B00DH9NB52"]
      expect{
        ProductPrioritySet.add_to_set(product_id, asins)
        }.to change(ProductPriority, :count).by(asins.length)
    end
  end

end
