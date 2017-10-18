require 'minitest/autorun'
require 'minitest/rg'
require_relative '../models/budget'
require_relative '../models/category'
require_relative '../models/limit'
require_relative '../models/transaction'
require_relative '../models/user'
require_relative '../models/vendor'

class TestBudget < Minitest::Test
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

    def test_budget_update()
        result = @budget.remaining()
        assert_equal(2000.0, result)
        @budget.remaining_update()

        expected = 1510.0
        result = @budget.remaining()
        assert_equal(expected, result)
    end

    def test_budget_check()
        @budget.remaining_update
        expected = "You have 75.5% of your budget remaining."
        assert_equal(expected, @budget.check())


        @transaction = Transaction.new( {'user_id' => @user.id, 'category_id' => @category1.id(), 'vendor_id' => @vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 1510.00 })
        @transaction.save()

        expected = "Warning, you only have 0.0% of your budget remaining."
        assert_equal(expected, @budget.check())


        @transaction7 = Transaction.new( {'user_id' => @user.id, 'category_id' => @category1.id(), 'vendor_id' => @vendor1.id, 'purchase_date' => '2017-01-27', 'amount_spent' => 100.00 })
        @transaction7.save()

        expected = "You have exceeded your budget by 5.0%. Doh..."
        assert_equal(expected, @budget.check())
    end

    def test_budget_initial_update()
        @budget.initial_update(500)
        result = @budget.initial()
        assert_equal(2500, result)

        @budget.initial_update(-1000)
        result = @budget.initial()
        assert_equal(1500, result)
    end
end
