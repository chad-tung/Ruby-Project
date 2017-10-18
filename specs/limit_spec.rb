require 'minitest/autorun'
require 'minitest/rg'
require_relative '../models/budget'
require_relative '../models/category'
require_relative '../models/limit'
require_relative '../models/transaction'
require_relative '../models/user'
require_relative '../models/vendor'

class TestLimit < Minitest::Test
    def setup()
        @user = User.new({'name' => 'Chad Tung', 'goals' => 'wish to save up for a coding course'})
        @user.save()

        @budget = Budget.new( { 'user_id' => @user.id, 'type' => 'monthly', 'initial' => 2000.00, 'remaining' => 2000.00 } )
        @budget.save()

        @category1 = Category.new( { 'name' => 'Food & Drink' } )
        @category2 = Category.new( { 'name' => 'Travel' } )
        @category3 = Category.new( { 'name' => 'Alchohol' } )
        @category1.save()
        @category2.save()
        @category3.save()

        @limit1 = Limit.new( { 'user_id' => @user.id, 'category_id' => @category1.id, 'percentage' => 0.4 } )
        @limit2 = Limit.new( { 'user_id' => @user.id, 'category_id' => @category2.id, 'percentage' => 0.1 } )
        @limit3 = Limit.new( { 'user_id' => @user.id, 'category_id' => @category3.id, 'percentage' => 0.1 } )
        @limit1.save()
        @limit2.save()
        @limit3.save()

        @vendor1 = Vendor.new( { 'name' => 'Marks & Spencers'})
        @vendor2 = Vendor.new( { 'name' => 'McDonald\'s'})
        @vendor3 = Vendor.new( { 'name' => 'Expat Bar'})
        @vendor1.save()
        @vendor2.save()
        @vendor3.save()

        @transaction1 = Transaction.new( { 'user_id' => @user.id, 'category_id' => @category1.id(), 'vendor_id' => @vendor2.id, 'purchase_date' => '2017-01-15', 'amount_spent' => 25.00 } )

        @transaction2 = Transaction.new( { 'user_id' => @user.id, 'category_id' => @category2.id(), 'vendor_id' => @vendor2.id, 'purchase_date' => '2017-01-15', 'amount_spent' => 15.00 } )

        @transaction3 = Transaction.new( { 'user_id' => @user.id, 'category_id' => @category3.id(), 'vendor_id' => @vendor3.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 200.00 } )

        @transaction4 = Transaction.new( { 'user_id' => @user.id, 'category_id' => @category1.id(), 'vendor_id' => @vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 250.00 } )
        @transaction1.save()
        @transaction2.save()
        @transaction3.save()
        @transaction4.save()

    end

    def teardown()
      @transaction1.delete()
      @transaction2.delete()
      @transaction3.delete()
      @transaction4.delete()
      @vendor1.delete()
      @vendor2.delete()
      @vendor3.delete()
      @limit1.delete()
      @limit2.delete()
      @limit3.delete()
      @category1.delete()
      @category2.delete()
      @category3.delete()
      @budget.delete()
      @user.delete()
    end

    #Limit

    def test_limit_check()
        result = @limit1.check()
        assert_equal("You have $525.0 remaining (65.63%) for food & drink.", result)

        @transaction = Transaction.new( {'user_id' => @user.id, 'category_id' => @category1.id(), 'vendor_id' => @vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 525.00 })
        @transaction.save()

        assert_equal("Warning, limit for food & drink reached.", @limit1.check)

        @transactionnew = Transaction.new( {'user_id' => @user.id, 'category_id' => @category1.id(), 'vendor_id' => @vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 525.00 })
        @transactionnew.save()

        assert_equal("Warning, limit for food & drink exceeded by $525.0 (65.63%). Immediately re-strategise your spending on food & drink.", @limit1.check())
    end

end
