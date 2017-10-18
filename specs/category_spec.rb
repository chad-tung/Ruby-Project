require 'minitest/autorun'
require 'minitest/rg'
require_relative '../models/budget'
require_relative '../models/category'
require_relative '../models/limit'
require_relative '../models/transaction'
require_relative '../models/user'
require_relative '../models/vendor'

class TestCategory < Minitest::Test
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
        Transaction.delete_all()
        Vendor.delete_all()
        Limit.delete_all()
        Category.delete_all()
        Budget.delete_all()
        User.delete_all()
    end

    def test_category_sum_transactions()
        result1 = @category1.sum_transactions
        result2 = @category2.sum_transactions
        assert_equal(275.00, result1)
        assert_equal(15.00, result2)
    end

    def test_limit_percentage()
        result1 = @category1.limit_percentage
        result2 = @category2.limit_percentage

        assert_equal(0.4, result1)
        assert_equal(0.1, result2)
    end
end
