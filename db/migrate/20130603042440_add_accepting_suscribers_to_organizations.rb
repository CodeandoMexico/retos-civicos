class AddAcceptingSuscribersToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :accepting_suscribers, :boolean, default: false

    Organization.update_all accepting_suscribers: false
  end
end
