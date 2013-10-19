require 'spec_helper'

describe 'ProductPrioritySet' do
  let!(:product_priority1) { FactoryGirl.create(:product_priority) }
  let!(:product_priority2) { FactoryGirl.create(:product_priority) }
  let!(:product_priority3) { FactoryGirl.create(:product_priority) }

  describe "add_to_set" do
    it "creates product priority objects" do
      product_id = 1
      asins = ["B00CHHCCDC","B00CHHBDQE","B00DH9OSWM","B00CHHBDA0","B00CHHBDAU","B00CHHB2QU","B00CHHB2T2","B00DH9NB52"]
      expect{
        ProductPrioritySet.add_to_set(product_id, asins)
      }.to change(ProductPriority, :count).by(asins.length)
    end
  end

  describe "next_batch" do
    it "returns the most frequently called ASINs from the set in a string" do
      expect(ProductPrioritySet.next_batch).to eq(product_priority1.asin)
    end
  end  

  describe "handle_new_product" do
    let(:product_hash_array) { [FactoryGirl.build(:product_hash), FactoryGirl.build(:product_hash, :asin => "B00DH9NB52")] }
    let!(:parent_product) { FactoryGirl.create(:product, :id => 1, :asin => "B00CHHBDA0") }
    let!(:product_priority3) { FactoryGirl.create(:product_priority, :asin => "B00DH9NB52") }

    let(:handle_new_product) { -> { ProductPrioritySet.handle_new_products(product_hash_array) } }
    
    it "creates new products in the database" do
      expect(handle_new_product).to change(Product, :count).by(2)
    end

    it "deletes the relevent entries in the ProductPriority set" do
      expect(handle_new_product).to change(ProductPriority, :count).by(-3)
    end
  end

  describe "persist_products" do
    let(:product_hash1) { FactoryGirl.build(:product_hash) }
    let(:product_hash2) { FactoryGirl.build(:product_hash, :asin => "B00DH9NB52") }
    let!(:parent_product) { FactoryGirl.create(:product, :id => 1, :asin => "B00CHHBDA0") }
    let!(:product_priority3) { FactoryGirl.create(:product_priority, :asin => "B00DH9NB52") }

    it "saves products in database and assigns similarity relationship with its parent product" do
      product_hash_array = [product_hash1, product_hash2]
      expect{
        ProductPrioritySet.persist_products(product_hash_array)
      }.to change(Product, :count).by(2)
    end
  end

  describe "delete_persisted_product_priorities" do
    let(:product_hash1) { FactoryGirl.build(:product_hash) }
    let(:product_hash2) { FactoryGirl.build(:product_hash, :asin => "B00DH9NB52") }

    it "destroys all ProductPriority entries pertaining to passed products" do
      product_hash_array = [product_hash1, product_hash2]
      expect{
        ProductPrioritySet.delete_persisted_product_priorities(product_hash_array)
      }.to change(ProductPriority, :count).by(-3)
    end
  end
end
