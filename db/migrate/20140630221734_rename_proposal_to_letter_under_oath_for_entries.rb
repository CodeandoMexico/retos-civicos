class RenameProposalToLetterUnderOathForEntries < ActiveRecord::Migration[5.0]
  def up
    rename_column :entries, :proposal_file, :letter_under_oath
  end

  def down
    rename_column :entries, :letter_under_oath, :proposal_file
  end
end
