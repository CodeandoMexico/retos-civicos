class RemoveLetterUnderOathFieldColumnFromEntries < ActiveRecord::Migration[5.0]
  def up
    remove_column :entries, :letter_under_oath
  end

  def down
    add_column :entries, :letter_under_oath, :string
  end
end
