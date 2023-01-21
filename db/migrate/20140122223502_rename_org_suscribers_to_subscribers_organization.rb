class RenameOrgSuscribersToSubscribersOrganization < ActiveRecord::Migration[5.0]
  def up
    rename_index :org_suscribers, 'index_org_suscribers_on_organization_id', 'index_subscribers_on_organization_id'
    rename_table :org_suscribers, :subscribers
  end

  def down
    rename_index :org_suscribers, 'index_subscribers_on_organization_id', 'index_org_suscribers_on_organization_id'
    rename_table :subscribers, :org_suscribers
  end
end
