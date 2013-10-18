require 'spec_helper'

describe Product do
  it { should validate_uniqueness_of(:amzn_id)}
  it { should validate_presence_of(:amzn_id)}
  it { should validate_presence_of(:buylink)}
  it { should validate_presence_of(:image)}
  it { should have_many(:images)}
end 
