require_relative '../db/sql_runner'

class Transaction

    attr_accessor :user_id, :category_id, :vendor_id, :purchase_date, :amount_spent
    attr_reader :id
    def initialize(options)
        @id = options['id'].to_i if options['id']
        @user_id = options['user_id'].to_i
        @category_id = options['category_id'].to_i
        @vendor_id = options['vendor_id'].to_i
        @purchase_date = options['purchase_date']
        @amount_spent = options['amount_spent'].to_f
    end

    def save()
        sql = "INSERT INTO transactions (user_id, category_id, vendor_id, purchase_date, amount_spent) VALUES ($1, $2, $3, $4, $5) RETURNING id;"
        values = [@user_id, @category_id, @vendor_id, @purchase_date, @amount_spent]
        transaction = SqlRunner.run(sql, values).first()
        @id = transaction['id'].to_i
    end

    def update()
        sql = "UPDATE transactions SET (user_id, category_id, vendor_id, purchase_date, amount_spent) VALUES ($1, $2, $3, $4, $5) WHERE id = $6;"
        values = [@user_id, @category_id, @vendor_id, @purchase_date, @amount_spent, @id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM transactions;"
        values = []
        results = SqlRunner.run(sql, values)
        return results.map { |transaction| Transaction.new(transaction) }
    end

    def self.find(id)
        sql = "SELECT * FROM transactions WHERE id = $1;"
        values = [id]
        result = SqlRunner.run(sql, values).first()
        return Transaction.new(result)
    end

    def delete()
        sql = "DELETE FROM transactions WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE FROM transactions;"
        values = []
        SqlRunner.run(sql, values)
    end

    def vendor()
        sql = "SELECT vendors.name FROM vendors WHERE vendors.id = $1;"
        values = [@vendor_id]
        return SqlRunner.run(sql, values).first()['name']
    end

end
