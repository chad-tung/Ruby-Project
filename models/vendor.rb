require_relative '../db/sql_runner'

class Vendor

    attr_accessor :name
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
    end

    def save()
        sql = "INSERT INTO vendors (name) VALUES ($1) RETURNING id;"
        values = [@name]
        result = SqlRunner.run(sql, values).first()
        @id = result['id'].to_i
    end

    def update()
        sql = "UPDATE vendors SET (name) =($1) WHERE id = $2;"
        values = [@name, @id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM vendors;"
        values = []
        results = SqlRunner.run(sql, values)
        return results.map { |vendor| Vendor.new(vendor) }
    end

    def delete()
        sql = "DELETE FROM vendors WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE FROM vendors;"
        values = []
        SqlRunner.run(sql, values)
    end

    def self.find(id)
        sql = "SELECT * FROM vendors WHERE vendors.id = $1"
        values = [id]
        vendor = SqlRunner.run(sql, values).first()
        return Vendor.new(vendor)
    end

    def transactions()
        sql = "SELECT * FROM transactions WHERE transactions.vendor_id = $1;"
        values = [@id]
        results = SqlRunner.run(sql, values)
        return results.map { |transaction| Transaction.new(transaction) }
    end

end
