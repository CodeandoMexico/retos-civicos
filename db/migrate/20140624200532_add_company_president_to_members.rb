class AddCompanyPresidentToMembers < ActiveRecord::Migration
  def change
    add_column :members, :company_president, :string
  end
end
