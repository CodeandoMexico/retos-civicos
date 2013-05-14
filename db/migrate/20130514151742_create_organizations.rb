class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|

      t.timestamps
    end
  end
end
