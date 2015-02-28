require 'spec_helper'

feature 'Organization admin downloads collaborators csv' do
  scenario 'of a challenge' do
    organization = create :organization
    organization_admin = create :user, userable: organization
    challenge = create :challenge, title: 'Reto activo', organization: organization
    juanito = create_member name: 'Juanito', email: 'juanito@example.com'
    create :collaboration, member: juanito, challenge: challenge

    sign_in_organization_admin(organization_admin)
    click_link 'Participantes'
    click_link 'Exportar CSV'

    should_have_csv_with_name "#{formatted_current_time}-participantes-#{organization.slug}-organizacion.csv"
    should_send_csv_with(
      'id' => juanito.id.to_s,
      'nombre' => 'Juanito',
      'email' => 'juanito@example.com',
      'fecha de registro' => '2013-04-10 20:53:00 -0500'
    )
  end

  def formatted_current_time
    Time.zone.now.strftime '%d%m%y-%H%Mhrs'
  end

  def should_have_csv_with_name(name)
    page.response_headers['Content-Disposition'].should include name
  end

  def create_member(attrs)
    create :member, user: (create :user, attrs), created_at: Time.zone.local(2013, 4, 10, 20, 53)
  end

  def should_send_csv_with(csv_hash)
    csv = []
    CSV.parse(page.body) { |row| csv << row }
    csv.should eq csv_hash.to_a.transpose
  end
end
