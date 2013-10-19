class RenameColumnSimProducts < ActiveRecord::Migration
  def change
    rename_column :products, :sim_products, :asins_of_sim_prods
  end
end
