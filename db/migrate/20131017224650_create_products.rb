class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :image
      t.string :title
      t.integer :price
      t.string :brand
      t.text :buylink

      t.timestamps
    end
  end
end
