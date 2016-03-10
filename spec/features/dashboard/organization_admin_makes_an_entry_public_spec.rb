require 'spec_helper'

feature 'Organization admin makes an entry public' do
  attr_reader :member, :organization, :challenge, :entry

  before do
    user = create :user, name: 'Juanito'
    other_user = create :user, name: 'Kylito'
    @member = create :member, user: user
    @other_member = create :member, user: other_user
    @organization = create :organization
    @challenge = create :challenge,
      title: 'Reto 1',
      organization: organization,
      starts_on: 10.days.ago,
      ideas_phase_due_on: 8.days.ago,
      ideas_selection_phase_due_on: 2.days.from_now,
      prototypes_phase_due_on: 1.month.from_now,
      finish_on: 4.months.from_now

    @entry = create :entry, name: 'Mi propuesta', challenge: challenge, member: member, description: 'lo resuelvo'
  end

  scenario 'in the entries list' do
    sign_in_user(@other_member.user)

    # let's verify if the entry page is NOT visible
    visit challenge_entry_path(challenge, entry)
    expect(page).not_to have_content entry.description
    visit '/'
    click_link @other_member.user.name
    click_link 'Cerrar sesión'
    sign_in_user(organization.admin)

    visit dashboard_path
    click_link 'Propuestas'

    # let's make an entry view public
    navigate_to(entry).click
    click_button 'Hacer pública'

    expect(current_full_path).to eq dashboard_entries_path(challenge_id: challenge.id)

    # let's check again, but now the entry SHOULD be visible
    visit challenge_entry_path(challenge, entry)
    expect(page).to have_content entry.description
    expect(current_path).to eq challenge_entry_path(challenge, entry)
  end

  def navigate_to(entry)
    find(:xpath, "//a[@href=\'#{dashboard_entry_path(entry)}?id=1\']")
  end

  def current_full_path
    uri = URI.parse(current_url)
    "#{uri.path}?#{uri.query}"
  end
end
