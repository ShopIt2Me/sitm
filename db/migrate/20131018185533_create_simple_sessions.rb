class CreateSimpleSessions < ActiveRecord::Migration
  def change
    create_table :simple_sessions do |t|
    	t.string :session_key
    	t.text :value
    	t.timestamps
    end
  end
end
