require 'spec_helper'

describe ProductPriority do
  it { should validate_uniqueness_of(:product_id).scoped_to(:asin) }
end
