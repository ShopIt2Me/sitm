class CreateImagesTable < ActiveRecord::Migration
  def change
    create_table :images_tables do |t|
      t.references :product
      t.text :img_link
    end
  end
end
