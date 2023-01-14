class AddNinshoToAuthentications < ActiveRecord::Migration[5.2]
  def self.up
    change_table(:authentications) do |t|
      ## Ninsho model fields
      t.string :oauth_token

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    add_index :authentications, :user_id
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
