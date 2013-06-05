class AddSubdomainToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :subdomain, :string
  end
end
