require 'spec_helper'

describe Product do

  let (:prod1_attrs) { FactoryGirl.build(:product_hash, asin: 'B00CTGB8OK', asins_of_sim_prods: "B00CTGB4M6,B00CTGB4OO,B00CTGB5FW,B00CTGB2X2,B00CTGB1Y2")}
  let (:prod2_attrs) { FactoryGirl.build(:product_hash, asin: 'B00CTGB4M6', asins_of_sim_prods: "B00CTGB4OO,B00CTGB5FW,B00CTGB2X2,B00CTGB1Y2")}


  it { should validate_uniqueness_of(:asin)}
  it { should validate_presence_of(:asin)}
  it { should validate_presence_of(:buylink)}
  it { should validate_presence_of(:department)}
  it { should validate_presence_of(:large_image)}
  it { should validate_presence_of(:small_image)}
  it { should validate_presence_of(:medium_image)}
  it { should have_many(:images)}
  it { should have_many(:similars)}
  it { should have_many(:similarprods)}
  it { should_not allow_value("girls").for(:department) }
  it { should_not allow_value("boys").for(:department) }
  it { should allow_value("mens").for(:department) }
  it { should allow_value("womens").for(:department) }

  it 'returns asins for similar products not in db as an array of strings' do
    
    prod1 = Product.create(prod1_attrs)
    prod2 = Product.create(prod2_attrs)
    
    expect(prod1.identify_missing_asins).to eq(['B00CTGB4OO','B00CTGB5FW','B00CTGB2X2','B00CTGB1Y2'])
    
  end

end
