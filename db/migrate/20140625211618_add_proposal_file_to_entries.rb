class AddProposalFileToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :proposal_file, :string
  end
end
