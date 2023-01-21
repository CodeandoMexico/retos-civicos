class AddCompanyPresidentToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :company_president, :string
  end
end
