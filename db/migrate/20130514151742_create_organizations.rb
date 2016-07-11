class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations, &:timestamps
  end
end
