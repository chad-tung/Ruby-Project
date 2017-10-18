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
        sql = "UPDATE limits SET (user_id, category_id, percentage) = ($1, $2, $3) WHERE id = $4;"
        values = [@user_id, @category_id, @percentage, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM limits WHERE id = $1;"
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
        sql = "SELECT * FROM limits WHERE limits.id = $1;"
        values = [id]
        limit = SqlRunner.run(sql, values).first()
        return Limit.new(limit)
    end

    def self.find_by_cat(category_id)
        sql = "SELECT * FROM limits WHERE limits.category_id = $1;"
        values = [category_id]
        limit = SqlRunner.run(sql, values).first()
        return Limit.new(limit)
    end

    def percentage_update(percentage)
        @percentage = percentage
        update()
    end


    def check()
        #For this function, we want to check how much of the limit they have consumed.
        #Get the amount_spent from transactions and the category name.
        sql = "SELECT transactions.amount_spent, categories.name FROM transactions INNER JOIN categories ON transactions.category_id = categories.id WHERE categories.id = $1;"
        values = [@category_id]

        #set variables which store these values. We know that category name will be the same, but for total, will have to sum up the amount_spent values.
        amounts = SqlRunner.run(sql, values)
        category = amounts.first()['name'].downcase()
        total = amounts.map { |transaction| transaction['amount_spent'].to_f }.sum()

        #Have to compare these values to the available budget for that category, so need the initial budget value
        sql2 = "SELECT budgets.initial FROM budgets;"
        values2 = []
        budget_initial = SqlRunner.run(sql2, values2).first()['initial'].to_f

        #Need to find out what the monetary value of the limit is based on the total budget and percentage allocated
        limit_budget = budget_initial * @percentage
        budget_left = limit_budget - total
        percentage_left = (budget_left/limit_budget * 100).round(2)

        #set up a string variables so we don't repeat ourselves.
        warning = "Warning, limit for #{category}"
        leftover = "You have $#{budget_left} remaining (#{percentage_left}%)"

        #Apply logic to show users how much they have left and warn them of overspending in certain categories.

        if total == limit_budget
            return "#{warning} reached."
        elsif total > limit_budget
            return "#{warning} exceeded by $#{- budget_left} (#{- percentage_left}%). Immediately re-strategise your spending on #{category}."
        elsif percentage_left < 20
            return "#{warning} is being approached. #{leftover}."
        else
            return "#{leftover} for #{category}."
        end
    end

    def self.check_all()
        all_limits = Limit.all()
        checker = []
        for limit in all_limits
            checker << limit.check()
        end
        return checker
    end
end
