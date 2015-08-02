require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where = params.keys.map {|param| "#{param} = ?"}.join(" AND ")

    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
     #{where}
    SQL
    parse_all(results)
  end
end

class SQLObject
  self.extend(Searchable)
end
