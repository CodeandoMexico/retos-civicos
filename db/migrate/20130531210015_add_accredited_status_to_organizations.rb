class AddAccreditedStatusToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :accredited, :boolean, default: false
  end
end
