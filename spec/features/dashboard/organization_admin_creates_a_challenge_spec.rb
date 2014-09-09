require 'spec_helper'

feature 'Organization admin creates a challenge' do
  attr_reader :member

  before do
    other_org_challenge = create :challenge
    organization = create :organization
    @member = create :member

    sign_in_organization_admin(organization.admin)
    visit new_organization_challenge_path(organization)
  end

  scenario 'with good params' do
    submit_challenge_with(
      title: 'Limpiemos México',
      pitch: 'Hagamos conciencia para un México limpio',
      image: image_fixture,
      infographic: image_fixture,
      organization_about: 'La organización limpia',
      entry_template_url: 'http://google.com',
      assessment_methodology: 'http://google.com',
      description: 'México esta muy sucio',
      starts_on: Date.current,
      ideas_phase_due_on: 1.month.from_now.to_date,
      ideas_selection_phase_due_on: 2.month.from_now.to_date,
      prototypes_phase_due_on: 3.month.from_now.to_date,
      finish_on: 4.month.from_now.to_date,
    )

    page_should_show_challenge_with(
      'Limpiemos México',
      'La organización limpia',
      'México esta muy sucio'
    )

    when_addding_an_entry_as(member) do
      entry_form_should_show_entry_template_url 'http://google.com'
    end
  end

  scenario 'with a bad but recoverable entry template url' do
    submit_challenge_with(
      title: 'Limpiemos México',
      pitch: 'Hagamos conciencia para un México limpio',
      image: image_fixture,
      infographic: image_fixture,
      organization_about: 'La organización limpia',
      entry_template_url: 'google.com',
      description: 'México esta muy sucio',
      assessment_methodology: 'google.com',
      starts_on: Date.current,
      ideas_phase_due_on: 1.month.from_now.to_date,
      ideas_selection_phase_due_on: 2.month.from_now.to_date,
      prototypes_phase_due_on: 3.month.from_now.to_date,
      finish_on: 4.month.from_now.to_date,
    )

    when_addding_an_entry_as(member) do
      entry_form_should_show_entry_template_url 'http://google.com'
    end
  end

  def submit_challenge_with(data)
    fill_in 'challenge_title', with: data.fetch(:title)
    fill_in 'challenge_pitch', with: data.fetch(:pitch)
    attach_file 'challenge_avatar', data.fetch(:image)
    attach_file 'challenge_infographic', data.fetch(:infographic)
    fill_in 'challenge_about', with: data.fetch(:organization_about)
    fill_in 'challenge_entry_template_url', with: data.fetch(:entry_template_url)
    fill_in 'challenge_description', with: data.fetch(:description)
    fill_in 'challenge_assessment_methodology', with: data.fetch(:assessment_methodology)
    fill_in 'challenge_starts_on', with: data.fetch(:starts_on)
    fill_in 'challenge_ideas_phase_due_on', with: data.fetch(:ideas_phase_due_on)
    fill_in 'challenge_ideas_selection_phase_due_on', with: data.fetch(:ideas_selection_phase_due_on)
    fill_in 'challenge_prototypes_phase_due_on', with: data.fetch(:prototypes_phase_due_on)
    fill_in 'challenge_finish_on', with: data.fetch(:finish_on)
    click_button 'Publicar'
  end

  def when_addding_an_entry_as(member)
    click_link 'Salir'
    sign_in_user(member)
    visit_last_challenge
    click_link 'Regístrate al reto aquí'
    yield
  end

  def page_should_show_challenge_with(*texts)
    texts.each { |text| page.should have_content text }
  end

  def visit_last_challenge
    visit challenge_path(Challenge.order('created_at DESC').first)
  end

  def entry_form_should_show_entry_template_url(url)
    find_link('plantilla')[:href].should eq url
  end

  def image_fixture
    Rails.root.join('app/assets/images/codeandomexico80.png')
  end
end
