require 'spec_helper'

describe Product do
  it { should validate_uniqueness_of(:asin)}
  it { should validate_presence_of(:asin)}
  it { should validate_presence_of(:buylink)}
  it { should validate_presence_of(:large_image)}
  it { should validate_presence_of(:small_image)}
  it { should validate_presence_of(:medium_image)}
  it { should have_many(:images)}
  it { should have_many(:similars)}
  it { should have_many(:similarprods)}
end
