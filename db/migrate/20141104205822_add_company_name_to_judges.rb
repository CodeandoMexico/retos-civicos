class AddCompanyNameToJudges < ActiveRecord::Migration[5.0]
  def change
    add_column :judges, :company_name, :string
  end
end
