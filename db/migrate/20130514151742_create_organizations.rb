class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations, &:timestamps
  end
end
