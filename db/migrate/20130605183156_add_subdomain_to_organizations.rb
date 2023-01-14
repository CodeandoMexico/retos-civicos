class AddSubdomainToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :subdomain, :string
  end
end
