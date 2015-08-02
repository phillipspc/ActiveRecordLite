require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.table_name
    @table_name ||= self.name.underscore.pluralize
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end


  def self.columns
    return @columns if @columns
    table = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    LIMIT
      0
    SQL
    table.first.map!(&:to_sym)
    @columns = table.first
  end

  def column_names
    @column_names = self.class.columns.join(", ")
  end


  def self.finalize!
    columns.each do |column|
      define_method("#{column}") {attributes[column]}
      define_method("#{column}=") do |input|
        attributes[column] = input
      end
    end
  end


  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
    *
    FROM
      #{table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result)}
  end


  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
    SELECT
    *
    FROM
      #{table_name}
    WHERE
    id = ?
    SQL
    parse_all(results).first
  end


  def initialize(params = {})
    attr_names = []
    values = params.values

    params.keys.each do |key|
      if self.class.columns.include?(key.to_sym)
        attr_names << key.to_sym
      else
        raise "unknown attribute '#{key}'"
      end
    end

    attr_names.each_with_index do |attr_name, idx|
      self.send("#{attr_name}=", values[idx])
    end
  end


  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end


  def question_marks
    n = attribute_values.count
    (['?'] * n).join(", ")
  end

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{column_names[4..-1]})
    VALUES
      (#{question_marks})
    SQL

    attributes[:id] = DBConnection.last_insert_row_id
  end


  def update
    set = self.class.columns.map {|column| "#{column} = ?"}.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, attributes[:id])
    UPDATE
    #{self.class.table_name}
    SET
    #{set}
    WHERE
      id = ?
    SQL
  end

  def save
    if attributes[:id].nil?
      insert
    else
      update
    end
  end
end


class Cat < SQLObject
  finalize!
end
