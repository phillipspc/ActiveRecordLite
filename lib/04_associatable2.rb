require_relative '03_associatable'

module Associatable
 def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      source = source_options.table_name
      source_fkey = source_options.foreign_key
      source_pkey = source_options.primary_key

      through = through_options.table_name
      through_fkey = through_options.foreign_key
      through_pkey = through_options.primary_key

      key = self.send(through_fkey)
      results = DBConnection.execute(<<-SQL, key)
      SELECT
        #{source}.*
      FROM
        #{through}
      JOIN
        #{source}
      ON
        #{through}.#{source_fkey} = #{source}.#{source_pkey}
      WHERE
        #{through}.#{through_pkey} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
end
