class ChangeSubdomainToSlugToOrganizations < ActiveRecord::Migration[5.2]
  def up
    rename_column :organizations, :subdomain, :slug
  end

  def down
    rename_column :organizations, :slug, :subdomain
  end
end
