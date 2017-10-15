require_relative '../db/sql_runner'

class Limit

    attr_reader :id, :user_id, :category_id
    attr_accessor :percentage

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @user_id = options['user_id'].to_i
        @category_id = options['category_id'].to_i
        @percentage = options['percentage'].to_f
    end

    def save()
        sql = "INSERT INTO limits (user_id, category_id, percentage) VALUES ($1, $2, $3) RETURNING id;"
        values = [@user_id, @category_id, @percentage]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i
    end

    def update()
        sql = "UPDATE limits SET (user_id, category_id, percentage) VALUES ($1, $2, $3) WHERE id = $4;"
        values = [@user_id, @category_id, @percentage, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE * FROM limits WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM limits;"
        values = []
        results = SqlRunner.run(sql, values)
        return results.map { |limit| Limit.new(limit) }
    end

    def self.delete_all()
        sql = "DELETE FROM limits;"
        values = []
        SqlRunner.run(sql, values)
    end

    def self.find(id)
        sql = "SELECT * FROM limits WHERE id = $1;"
        values = [id]
        limit = SqlRunner.run(sql, values).first()
        return Limit.new(limit)
    end
end
