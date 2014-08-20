require 'spec_helper'

feature 'Organization admin updates organization profile' do
  scenario 'from the dashboard' do
    organization = create :organization
    sign_in_organization_admin(organization.admin)

    click_on 'Editar Perfil'
    fill_in 'organization_name', with: 'Updated org name'
    click_button 'Actualizar'

    current_path.should eq dashboard_path
    dashboard_should_show_the_new_name('Updated org name')
  end

  def dashboard_should_show_the_new_name(new_name)
    page.should have_content new_name
  end
end
