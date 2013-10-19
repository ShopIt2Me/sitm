class AddSimProductsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sim_products, :text
    rename_column :products, :amzn_id, :asin
  end
end


