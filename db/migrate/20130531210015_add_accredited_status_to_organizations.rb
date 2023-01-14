class AddAccreditedStatusToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :accredited, :boolean, default: false
  end
end
