require_relative '../db/sql_runner'

class User

    attr_accessor :name, :goals
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @goals = options['goals']
    end

    def save()
        sql = "INSERT INTO users (name, goals) VALUES ($1, $2) RETURNING id;"
        values = [@name, @goals]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i
    end

    def update()
        sql = "UPDATE users SET (name, goals) = ($1, $2) WHERE id = $3;"
        values = [@name, @goals, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM users WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE from users;"
        values = []
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = 'SELECT * FROM users;'
        values = []
        results = SqlRunner.run(sql, values)
        return results.map { |user| User.new(user) }
    end

    def self.find(id)
        sql = "SELECT * FROM users WHERE id = $1;"
        values = [id]
        user = SqlRunner.run(sql, values).first()
        return User.new(user)
    end

    def budget()
        sql = "SELECT * FROM budgets WHERE budgets.user_id = $1;"
        values = [@id]
        result = SqlRunner.run(sql, values).first()
        return Budget.new(result)
    end

end
