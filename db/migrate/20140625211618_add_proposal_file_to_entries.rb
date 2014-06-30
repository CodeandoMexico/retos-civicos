class AddProposalFileToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :proposal_file, :string
  end
end
