class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations, &:timestamps
  end
end
