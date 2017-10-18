require_relative '../db/sql_runner'

class Category

    attr_accessor :name
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
    end

    def save()
        sql = "INSERT INTO categories (name) values ($1) RETURNING id;"
        values = [@name]
        result = SqlRunner.run(sql, values).first()
        @id = result['id']
    end

    def update()
        sql = "UPDATE categories SET (name) = ($1) WHERE id = $2;"
        values = [@name, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM categories WHERE categories.id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM categories;"
        values = []
        results = SqlRunner.run(sql, values)
        return results.map { |category| Category.new(category) }
    end

    def self.delete_all()
        sql = "DELETE FROM categories;"
        values = []
        SqlRunner.run(sql, values)
    end

    def self.find(id)
        sql = "SELECT * FROM categories WHERE categories.id = $1;"
        values = [id]
        category = SqlRunner.run(sql, values).first()
        return Category.new(category)
    end

    def transactions()
        sql = "SELECT * FROM transactions WHERE transactions.category_id = $1;"
        values = [@id]
        results = SqlRunner.run(sql, values)
        return results.map { |transaction| Transaction.new(transaction) }
    end

    def sum_transactions()
        sql = "SELECT transactions.amount_spent FROM transactions WHERE transactions.category_id = $1;"
        values = [@id]
        results = SqlRunner.run(sql, values)
        expenditure = results.map {|transaction| transaction['amount_spent'].to_f}
        return expenditure.sum()
    end

    def limit_percentage()
        sql = "SELECT limits.percentage FROM limits WHERE limits.category_id = $1;"
        values = [@id]
        result = SqlRunner.run(sql, values).first()['percentage'].to_f
        return result
    end

    def limits()
        sql = "SELECT * FROM limits WHERE limits.category_id = $1;"
        values = [@id]
        result = SqlRunner.run(sql, values).first()
        return Limit.new(result)
    end



end
