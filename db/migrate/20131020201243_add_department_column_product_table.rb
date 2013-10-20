class AddDepartmentColumnProductTable < ActiveRecord::Migration
  def change
    add_column :products, :department, :string
  end
end
