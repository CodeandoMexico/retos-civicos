class AddCompanyToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :company_name, :string
    add_column :entries, :company_rfc, :string
  end
end
