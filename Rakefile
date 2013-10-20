# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Sitm::Application.load_tasks

desc "Seed db with products"
task "db:seed" do
  start_count = Product.count
  10.times do |n|
    page = (n+1).to_s
    if random_asins = ProductLookup.get_ten_asins(page,'Women')
      sleep 1
      products = ProductLookup.load_product_batch(random_asins.join(','))
      products.each do |product|
        new_product = Product.create(product)
        puts "Seeded #{new_product.title}..."
      end
    end
  #once relationship table has been created we will also want to create relationships for each similar product
  end
  puts "**************************************************************"
  puts "SEEDED #{Product.count - start_count} PRODUCTS. TIME TO PARTY!"
end
