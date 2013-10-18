module ApplicationHelper

  def generate_session_key
    ary = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    key = []
    15.times { key << ary.sample }
    key.join
  end

end
