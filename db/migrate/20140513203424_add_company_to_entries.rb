class AddCompanyToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :company_name, :string
    add_column :entries, :company_rfc, :string
  end
end
