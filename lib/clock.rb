require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

handler do |job|
  products_to_be_queried = ProductPriority.count
  if products_to_be_queried > 0
    puts "#{Time.now}: Querying Amazon for #{products_to_be_queried} products"
    ProductPrioritySet.send_next_batch
  else
    puts "#{Time.now}: No products to be queried.."
  end
end

every(10.seconds, 'Querying Amazon API..')
