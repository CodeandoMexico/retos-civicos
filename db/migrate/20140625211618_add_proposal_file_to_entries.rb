class AddProposalFileToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :proposal_file, :string
  end
end
