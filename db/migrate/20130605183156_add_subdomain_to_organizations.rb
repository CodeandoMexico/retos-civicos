class AddSubdomainToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :subdomain, :string
  end
end
