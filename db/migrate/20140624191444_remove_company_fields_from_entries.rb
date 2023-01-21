class RemoveCompanyFieldsFromEntries < ActiveRecord::Migration[5.0]
  def up
    remove_column :entries, :company_name
    remove_column :entries, :company_rfc
  end

  def down
    add_column :entries, :company_name, :string
    add_column :entries, :company_rfc, :string
  end
end
