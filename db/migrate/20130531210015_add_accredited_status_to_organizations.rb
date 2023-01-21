class AddAccreditedStatusToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :accredited, :boolean, default: false
  end
end
