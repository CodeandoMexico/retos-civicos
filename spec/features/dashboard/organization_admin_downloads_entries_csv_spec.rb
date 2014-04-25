require 'spec_helper'

feature 'Organization admin downloads entries CSV' do
  scenario 'of a challenge' do
    user = create :user, name: 'Juanito'
    member = create :member, user: user
    organization = create :organization
    organization_admin = create :user, userable: organization
    challenge = create :challenge, :inactive, title: 'Reto 1', organization: organization

    entry = create :entry, :public,
      member: member,
      challenge: challenge,
      name: 'Mi propuesta',
      description: 'la mejor',
      live_demo_url: 'http://mipropuesta.com',
      technologies: 'PHP, Rust',
      created_at: Time.zone.local(2014,4,25,10,52,24)

    sign_in_organization_admin(organization_admin)
    click_link 'Propuestas'
    click_link 'Exportar CSV'

    should_have_csv_with(
      'id' => entry.id.to_s,
      'nombre' => 'Mi propuesta',
      'reto' => 'Reto 1',
      'fecha' => '2014-04-25 10:52:24 -0500',
      'descripción' => 'la mejor',
      'link' => 'http://mipropuesta.com',
      'tecnologías' => 'PHP, Rust',
      'participante' => 'Juanito',
      'pública' => 'true'
    )
  end

  def should_have_csv_with(csv_hash)
    csv = []
    CSV.parse(page.body) { |row| csv << row }
    csv.should eq csv_hash.to_a.transpose
  end
end
