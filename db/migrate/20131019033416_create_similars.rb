class CreateSimilars < ActiveRecord::Migration
  def change
    create_table :similars do |t|
      t.integer :similarprod_id
      t.integer :product_id
    end
  end
end

