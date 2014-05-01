class ChangeSubdomainToSlugToOrganizations < ActiveRecord::Migration
  def up
    rename_column :organizations, :subdomain, :slug
  end

  def down
    rename_column :organizations, :slug, :subdomain
  end
end
