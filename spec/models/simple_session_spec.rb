require 'spec_helper'

describe SimpleSession do
  it { should validate_uniqueness_of(:session_key)}
  it { should validate_presence_of(:session_key)}
end
