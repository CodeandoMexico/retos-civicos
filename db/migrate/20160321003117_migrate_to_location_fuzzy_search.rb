class MigrateToLocationFuzzySearch < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute <<-SQL
    DROP TABLE IF EXISTS searches;
    DROP VIEW IF EXISTS searches;
    CREATE VIEW searches AS
      SELECT locations.id AS searchable_id, locations.zip_code AS zip_code, locations.city AS city,
              locations.state AS state, locations.locality AS locality,
              CAST('Location' AS varchar) AS searchable_type FROM locations
    SQL
  end

  def down
  end
end
