class AddWelcomeMailToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :welcome_mail, :text
  end
end
