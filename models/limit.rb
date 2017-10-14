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

end
