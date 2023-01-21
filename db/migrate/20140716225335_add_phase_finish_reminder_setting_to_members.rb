class AddPhaseFinishReminderSettingToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :phase_finish_reminder_setting, :boolean, null: false, default: true
  end
end
