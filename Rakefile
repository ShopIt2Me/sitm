# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Sitm::Application.load_tasks

desc "Seed db with products"
task "db:seed" do
	@asins = ProductLookup.get_ten_asins
	p @asins
	@asins.each do |asin|
		prod_attrs = ProductLookup.load_from_asin(asin)[:product_attributes]
		prod_attrs["amzn_id"] = asin
		prod_obj = Product.create(prod_attrs)
		#once relationship table has been created we will also want to create relationships for each similar product
	end
end
