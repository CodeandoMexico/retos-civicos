class MigrateToLocationFuzzySearch < ActiveRecord::Migration
  def up
    execute "create extension pg_trgm"
    execute "create extension intarray"
    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW searches AS
      SELECT locations.id AS searchable_id, locations.zip_code AS zip_code, locations.city AS city,
              locations.state AS state, locations.locality AS locality,
              CAST('Location' AS varchar) AS searchable_type FROM locations
    SQL
  end

  def down
    DROP VIEW searches
    execute "drop extension pg_trgm"
    execute "drop extension intarray"
  end
end
