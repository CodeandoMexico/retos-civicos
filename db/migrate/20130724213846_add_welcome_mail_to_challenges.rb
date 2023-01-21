class AddWelcomeMailToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :welcome_mail, :text
  end
end
