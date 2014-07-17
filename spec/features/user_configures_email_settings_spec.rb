require 'spec_helper'

feature 'User configures email settings' do
  scenario 'for phase finish reminder' do
    member = create :member

    sign_in_user(member)

    visit edit_member_path(member)
    phase_finish_reminder_checkbox.should be_checked
    uncheck('member_phase_finish_reminder_setting')
    click_button 'Actualizar'

    visit edit_member_path(member)
    phase_finish_reminder_checkbox.should_not be_checked
  end

  def phase_finish_reminder_checkbox
    find('#member_phase_finish_reminder_setting')
  end
end
