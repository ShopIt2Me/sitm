class UpdateProductAttributes < ActiveRecord::Migration
  def change
    add_column :products, :small_image, :text
    add_column :products, :medium_image, :text
    rename_column :products, :image, :large_image
    change_column :products, :price, :string
  end
end
