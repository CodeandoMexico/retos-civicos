class AddCompanyNameToJudges < ActiveRecord::Migration
  def change
    add_column :judges, :company_name, :string
  end
end
