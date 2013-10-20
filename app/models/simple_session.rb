class SimpleSession < ActiveRecord::Base
	validates_presence_of :session_key
  validates_uniqueness_of :session_key

  serialize :value, Hash
end