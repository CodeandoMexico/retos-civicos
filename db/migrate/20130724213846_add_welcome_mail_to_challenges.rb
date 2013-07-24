class AddWelcomeMailToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :welcome_mail, :text
  end
end
