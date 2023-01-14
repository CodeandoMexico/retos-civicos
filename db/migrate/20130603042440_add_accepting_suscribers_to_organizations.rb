class AddAcceptingSuscribersToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :accepting_suscribers, :boolean, default: false

    Organization.update_all accepting_suscribers: false
  end
end
