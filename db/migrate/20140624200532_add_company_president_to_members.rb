class AddCompanyPresidentToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :company_president, :string
  end
end
