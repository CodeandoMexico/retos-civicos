class AddEntryTemplateUrlToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :entry_template_url, :string
  end
end
