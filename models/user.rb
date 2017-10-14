require_relative '../db/sql_runner'

class User

    attr_accessor :name, :reason
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @reason = options['reason']
    end

    def save()
        sql = "INSERT INTO users (name, reason) VALUES ($1, $2) RETURNING id;"
        values = [@name, @reason]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i
    end

    def update()
        sql = "UPDATE users SET (name, reason) VALUES ($1, $2) WHERE id = $3;"
        values = [@name, @reason, @id]
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

end
