class AddEntryTemplateUrlToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :entry_template_url, :string
  end
end
