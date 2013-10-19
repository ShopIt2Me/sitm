class CreateProductPriorities < ActiveRecord::Migration
  def change
    create_table :product_priorities do |t|
      t.integer :product_id
      t.string  :asin
      t.timestamps
    end
  end
end
