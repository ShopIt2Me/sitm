# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Sitm::Application.load_tasks

desc "Seed db with products"
task "db:seed" do
  10.times do |n|
    page = (n+1).to_s
    if random_asins = ProductLookup.get_ten_asins(page)
      sleep 1
      products = ProductLookup.load_product_batch(random_asins.join(','))
      products.each do |product|
        Product.create(product)
        print '.'
      end
    end
  end
  puts "\n#{Product.count} products in the DB! TIME TO PARTY!"

  #once relationship table has been created we will also want to create relationships for each similar product
end
