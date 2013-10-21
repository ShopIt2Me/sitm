require 'spec_helper'

describe SimpleSession do
  let(:simple_session) { FactoryGirl.create(:simple_session) }
  let(:product) { FactoryGirl.create(:product) }
  it { should validate_uniqueness_of(:session_key)}
  it { should validate_presence_of(:session_key)}

  it "should show ary of likes" do 
    expect(simple_session.ary_of_likes).to eq([1])
  end

  it "should show ary of displayed product ids" do
    expect(simple_session.ary_of_displayed_ids).to eq([])
  end

  it "should update ary of likes given a single liked product id" do 
    simple_session.update_liked_ids(2)
    expect(simple_session.ary_of_likes).to eq([1,2])
  end

  it "should update displayed product ids given an array of loaded product ids" do
    simple_session.update_displayed_ids([2,3])
    expect(simple_session.ary_of_displayed_ids).to eq([2,3])
  end

  it ".update_displayed_ids accepts an array of Product objects" do
    simple_session.update_displayed_ids([5,7])
    simple_session.update_displayed_ids([product])
    expect(simple_session.ary_of_displayed_ids).to eq([5,7,product.id])
  end
end
