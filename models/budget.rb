require_relative '../db/sql_runner'

class Budget

    attr_accessor :type, :initial, :remaining
    attr_reader :id, :user_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @user_id = options['user_id']
        @type = options['type']
        @initial = options['initial'].to_f
        @remaining = options['remaining'].to_f
    end

    def save()
        sql = "INSERT INTO budgets (user_id, type, initial, remaining) VALUES ($1, $2, $3, $4) RETURNING id;"
        values = [@user_id, @type, @initial, @remaining]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i
    end

    def update()
        sql = "UPDATE budgets SET (user_id, type, initial, remaining) = ($1, $2, $3, $4) WHERE id = $5;"
        values = [@user_id, @type, @initial, @remaining, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM budgets WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM budgets;"
        values = []
        results = SqlRunner.run(sql, values)
        return results.map { |budget| Budget.new(budget) }
    end

    def self.delete_all()
        sql = "DELETE FROM budgets;"
        values = []
        SqlRunner.run(sql, values)
    end

    def self.find(id)
        sql = "SELECT * FROM budgets WHERE id = $1;"
        values = [id]
        budget = SqlRunner.run(sql, values).first()
        return Budget.new(budget)
    end

    def remaining_update()
        sql = "SELECT transactions.amount_spent FROM transactions WHERE transactions.user_id = $1;"
        values = [@user_id]
        results = SqlRunner.run(sql, values)
        total_transactions = results.map { |amount| amount['amount_spent'].to_f }
        @remaining = @initial - total_transactions.sum()
        update()
    end

    def check()
        remaining_update()
        sql = "SELECT budgets.initial, budgets.remaining FROM budgets WHERE id = $1;"
        values = [@id]
        initial = SqlRunner.run(sql, values).first()['initial'].to_f
        remaining = SqlRunner.run(sql, values).first()['remaining'].to_f
        percentage_left = (remaining/initial * 100).round(2)
        string = "#{percentage_left}% of your budget remaining."
        if percentage_left < 0
            return "You have exceeded your budget by #{- percentage_left}%. Doh..."
        elsif percentage_left < 20
            return "Warning, you only have #{string}"
        else
            return "You have #{string}"
        end
    end

end
