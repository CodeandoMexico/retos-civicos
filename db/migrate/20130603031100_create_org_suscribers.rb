class CreateOrgSuscribers < ActiveRecord::Migration
  def change
    create_table :org_suscribers do |t|
      t.string :email
      t.integer :organization_id

      t.timestamps
    end

    add_index :org_suscribers, :organization_id
  end
end
