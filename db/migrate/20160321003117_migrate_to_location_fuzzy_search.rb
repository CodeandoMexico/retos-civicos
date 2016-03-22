class MigrateToLocationFuzzySearch < ActiveRecord::Migration
  def up
    execute "create extension pg_trgm"
    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW searches AS
      SELECT locations.id AS searchable_id, locations.zip_code AS zip_code, locations.city AS city,
              locations.state AS state, locations.locality AS locality,
              CAST('Location' AS varchar) AS searchable_type FROM locations
    SQL
  end

  def down
    DROP VIEW IF EXISTS searches
    execute "drop extension pg_trgm"
  end
end
