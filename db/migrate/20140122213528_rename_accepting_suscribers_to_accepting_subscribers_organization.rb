class RenameAcceptingSuscribersToAcceptingSubscribersOrganization < ActiveRecord::Migration[5.0]
  def up
    rename_column :organizations, :accepting_suscribers, :accepting_subscribers
  end

  def down
    rename_column :organizations, :accepting_subscribers, :accepting_suscribers
  end
end
