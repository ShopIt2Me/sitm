require 'spec_helper'

describe ProductPriority do
  it { should validate_presence_of(:asin)}
  it { should validate_presence_of(:product_id)}
end
