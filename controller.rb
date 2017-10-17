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
    erb( :categories_limits )
end

post '/moneycashboard/transaction-complete' do
    @transaction = Transaction.new(params)
    @transaction.save()
    erb( :transaction_complete )
end
