class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :product
      t.text :img_link
    end
  end
end
