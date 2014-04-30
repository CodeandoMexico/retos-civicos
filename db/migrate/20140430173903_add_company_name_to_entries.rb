class AddCompanyNameToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :company_name, :string
  end
end
