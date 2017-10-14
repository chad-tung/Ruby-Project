require_relative '../db/sql_runner'

class Budget

    attr_accessor :type, :initial, :remaining
    attr_reader :id, :user_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @user_id = options['user_id']
        @type = options['type']
        @initial = options['initial']
        @remaining = options['remaining']
    end

    def save()
        sql = "INSERT INTO budgets (user_id, type, initial, remaining) VALUES ($1, $2, $3, $4);"
        values = [@user_id, @type, @initial, @remaining]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i
    end

    def update()
        sql = "UPDATE budgets SET (user_id, type, initial, remaining) VALUES ($1, $2, $3, $4) WHERE id = $5;"
        values = [@user_id, @type, @initial, @remaining, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM budgets WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
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

end
