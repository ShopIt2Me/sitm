# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Sitm::Application.load_tasks

desc "Seed db with products"
task "db:seed" do
  start_time = Time.now
  start_count = Product.count
  30.times do |n|
    if random_asins = ProductLookup.get_ten_asins
      sleep 1
      products = ProductLookup.load_product_batch(random_asins.join(','))
      products.each do |product|
        unless Product.find_by(product)
          new_product = Product.create(product)
          puts "Seeded #{new_product.title}..."
        end
      end
    end
  #once relationship table has been created we will also want to create relationships for each similar product
  end
  puts "**************************************************************"
  puts "SEEDED #{Product.count - start_count} PRODUCTS. DEFINING RELATIONSHIPS..."

  relationship_count = 0
  Product.all.each do |product|
    sim_prod_array = product.asins_of_sim_prods.split(',')
    sim_prod_array.each do |asin|
      if sim_product = Product.find_by(asin: asin)
        unless product.similarprods.include?(sim_product)
          product.similarprods << sim_product
          puts "Defined relationship for #{product.title} and #{sim_product.title}..."
          relationship_count += 1
        end
      end
    end
  end
  puts "**************************************************************"
  puts "ALL DONE!"
  puts "SEEDED #{Product.count - start_count} PRODUCTS. DEFINED #{relationship_count} RELATIONSHIPS. TOTAL TIME: #{Time.at(Time.now - start_time).gmtime.strftime('%R:%S')}"
end

desc "Connect products with each other by similarity in db "
task "db:connect_similar" => :environment do
  relationship_count = 0
  Product.all.each do |product|
    sim_prod_array = product.asins_of_sim_prods.split(',')
    sim_prod_array.each do |asin|
      if sim_product = Product.find_by(asin: asin)
        unless product.similarprods.include?(sim_product)
          product.similarprods << sim_product
          puts "Defined relationship for #{product.title} and #{sim_product.title}..."
          relationship_count += 1
        end
      end
    end
  end
  puts "**************************************************************"
  puts "DEFINED #{relationship_count} RELATIONSHIPS. "
end
