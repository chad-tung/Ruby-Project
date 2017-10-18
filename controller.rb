require 'sinatra'
require 'sinatra/contrib/all'
require 'pry-byebug'

require_relative 'models/user'
require_relative 'models/budget'
require_relative 'models/limit'
require_relative 'models/category'
require_relative 'models/vendor'
require_relative 'models/transaction'

get '/moneycashboard' do
    @users = User.all()
    @user = User.all().first()
    @categories = Category.all()
    @vendors = Vendor.all()
    @transactions = Transaction.all()
    erb( :homepage )
end

get '/moneycashboard/view_transactions' do
    @transactions = Transaction.all()
    erb( :transactions )
end

get '/moneycashboard/view_vendors' do
    @vendors = Vendor.all()
    erb( :vendors )
end

get '/moneycashboard/categories_limits' do
    @categories = Category.all()
    @limits = Limit.all()
    @vendors = Vendor.all()
    @budget = Budget.all().first()
    @budget.remaining_update()
    erb( :categories_limits )
end

get '/moneycashboard/budget' do
    @budget = Budget.all().first()
    @budget.remaining_update()
    erb( :budget )
end

post '/moneycashboard/transaction-complete' do
    @transaction = Transaction.new(params)
    @transaction.save()
    @budget = Budget.all().first()
    @budget.remaining_update
    erb( :transaction_complete )
end

post '/moneycashboard/transaction-deleted/:id' do
    @transaction = Transaction.find(params['id'])
    @transaction.delete()
    erb( :transaction_complete )
end

post '/moneycashboard/budget-updated' do
    @budget = Budget.all().first()
    @budget.initial_update(params['value'].to_f)
    @budget.remaining_update
    erb( :budget )
end

post '/moneycashboard/limit-updated' do
    @limit = Limit.find_by_cat(params['category_id'].to_i)
    @limit.percentage_update(params['percentage'].to_f / 100)
    erb( :limit_updated )
end

post '/moneycashboard/vendor-added' do
    @vendor = Vendor.new(params)
    @vendor.save()
    erb( :vendor_added )
end
