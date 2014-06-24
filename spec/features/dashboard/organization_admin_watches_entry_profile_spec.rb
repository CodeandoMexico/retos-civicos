require 'spec_helper'

feature 'Organization admin watches entry profile' do
  scenario 'that shows the entry deatails' do
    user = create :user, name: 'Juanito'
    member = create :member, user: user,
      company_name: 'Empresa de Juanito',
      company_rfc: 'Juanito2014'

    organization = create :organization
    challenge = create :challenge, title: 'Reto 1', organization: organization
    create :collaboration, member: member, challenge: challenge

    entry = create :entry,
      name: 'Propuesta 1',
      member: member,
      challenge: challenge,
      live_demo_url: 'http://miproyecto.com',
      created_at: Time.zone.local(2013, 4, 10, 20, 53),
      technologies: ['', 'PHP', 'MySQL'],
      description: 'Este reto se resuelve con tecnología'

    sign_in_organization_admin(organization.admin)
    click_link 'Propuestas'
    click_link 'Propuesta 1'

    page_should_have_entry_with(
      name: 'Propuesta 1',
      challenge: 'Reto 1',
      company_name: 'Empresa de Juanito',
      company_rfc: 'Juanito2014',
      sent_at: 'Abril 10, 2013 20:53',
      logo: entry.image_url,
      tecnologies: 'PHP, MySQL',
      description: 'Este reto se resuelve con tecnología',
      live_demo_link: 'http://miproyecto.com'
    )
  end

  def page_should_have_entry_with(args)
    page.should have_content args.fetch(:name)
    page.should have_content args.fetch(:challenge)
    page.should have_content args.fetch(:company_name)
    page.should have_content args.fetch(:company_rfc)
    page.should have_content args.fetch(:sent_at)
    page.should have_css "img[src='#{args.fetch(:logo)}']"
    page.should have_content args.fetch(:tecnologies)
    page.should have_content args.fetch(:description)
    page.should have_content args.fetch(:live_demo_link)
  end
end
