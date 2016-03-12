require 'spec_helper'
feature 'Organization admin' do
  attr_reader :organization_admin

  before do
    organization = create :organization, slug: 'unique-slug'
    @organization_admin = create :user, userable: organization
    challenge = create :challenge, title: 'Reto activo', organization: organization
  end

  scenario 'edits his slug' do
    sign_in_organization_admin(organization_admin)
    visit_organization_profile
    # verify current slug
    expect(page).to have_selector("input[value='unique-slug']")

    # change slug and verify the website reditects to the dashboard
    change_slug_information_with 'another-slug'
    current_path.should eq dashboard_path

    # verify slug has been successfully saved
    visit_organization_profile
    expect(page).to have_selector("input[value='another-slug']")
  end

  scenario 'edits its slug to a new one but it is already used by another organization' do
    new_organization = create :organization
    new_organization_admin = create :user, userable: new_organization

    sign_in_organization_admin(new_organization_admin)
    visit_organization_profile

    change_slug_information_with 'unique-slug'
    expect(page).to have_content 'Slug ya ha sido tomado'
  end

  def visit_organization_profile
    click_link 'Perfil'
  end

  def change_slug_information_with(new_slug)
    fill_in 'organization_slug', with: new_slug
    click_on 'Actualizar'
  end
end
