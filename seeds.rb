require_relative 'models/user'
require_relative 'models/budget'
require_relative 'models/category'
require_relative 'models/limit'
require_relative 'models/vendor'
require_relative 'models/transaction'

require 'pry-byebug'

Transaction.delete_all()
Vendor.delete_all()
Limit.delete_all()
Category.delete_all()
Budget.delete_all()
User.delete_all()

user = User.new({'name' => 'Jayne Kenny', 'goals' => 'wish to save up for a 2 year teaching course in Australia'})
user.save()

budget = Budget.new( { 'user_id' => user.id, 'type' => 'monthly', 'initial' => 2000.00, 'remaining' => 2000.00 } )
budget.save()

category1 = Category.new( { 'name' => 'Food & Drink' } )
category2 = Category.new( { 'name' => 'Travel' } )
category3 = Category.new( { 'name' => 'Alchohol' } )
category4 = Category.new( { 'name' => 'Clothes' } )
category1.save()
category2.save()
category3.save()
category4.save()

limit1 = Limit.new( { 'user_id' => user.id, 'category_id' => category1.id, 'percentage' => 0.4 } )
limit2 = Limit.new( { 'user_id' => user.id, 'category_id' => category2.id, 'percentage' => 0.1 } )
limit3 = Limit.new( { 'user_id' => user.id, 'category_id' => category3.id, 'percentage' => 0.1 } )
limit4 = Limit.new( { 'user_id' => user.id, 'category_id' => category4.id, 'percentage' => 0.2 } )
limit1.save()
limit2.save()
limit3.save()
limit4.save()

vendor1 = Vendor.new( { 'name' => 'Marks & Spencers'})
vendor2 = Vendor.new( { 'name' => 'McDonald\'s'})
vendor3 = Vendor.new( { 'name' => 'Expat Bar'})
vendor4 = Vendor.new( { 'name' => 'Minibus'})
vendor1.save()
vendor2.save()
vendor3.save()
vendor4.save()

transaction1 = Transaction.new( { 'user_id' => user.id, 'category_id' => category1.id(), 'vendor_id' => vendor2.id, 'purchase_date' => '2017-01-15', 'amount_spent' => 25.00 } )

transaction2 = Transaction.new( { 'user_id' => user.id, 'category_id' => category2.id(), 'vendor_id' => vendor4.id, 'purchase_date' => '2017-01-15', 'amount_spent' => 15.00 } )

transaction3 = Transaction.new( { 'user_id' => user.id, 'category_id' => category3.id(), 'vendor_id' => vendor3.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 200.00 } )

transaction4 = Transaction.new( { 'user_id' => user.id, 'category_id' => category4.id(), 'vendor_id' => vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 250.00 } )

transaction5 = Transaction.new( { 'user_id' => user.id, 'category_id' => category1.id(), 'vendor_id' => vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 47.00 } )

transaction1.save()
transaction2.save()
transaction3.save()
transaction4.save()
transaction5.save()

budget.remaining_update()

binding.pry
nil
