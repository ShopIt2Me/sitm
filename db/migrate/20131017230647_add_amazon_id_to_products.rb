class AddAmazonIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :amzn_id, :string
  end
end
