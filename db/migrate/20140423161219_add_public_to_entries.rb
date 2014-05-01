class AddPublicToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :public, :boolean, default: false, null: false

    Entry.reset_column_information
    Entry.update_all public: true
  end

  def down
    remove_column :entries, :public
  end
end
