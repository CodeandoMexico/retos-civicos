require 'spec_helper'

describe SubscribersController do
  describe 'GET create' do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:email) { 'email1@org.org' }
    describe 'given user is not subscribed already' do
      it 'redirects to organization page with a notice' do
        get :create, locale: 'en', organization_id: organization.id, email: email
        expect(response).to redirect_to(organization)
        expect(flash[:notice]).to eq('Gracias por suscribirte! Te prometemos buenas noticias, no spam.')
      end
    end

    describe 'given user is subscribed already' do
      it 'redirects to organization page with an error' do
        get :create, locale: 'en', organization_id: organization.id, email: email
        expect(response).to redirect_to(organization)
        expect(flash[:notice]).to eq('Gracias por suscribirte! Te prometemos buenas noticias, no spam.')
        get :create, locale: 'en', organization_id: organization.id, email: email
        expect(response).to redirect_to(organization)
        expect(flash[:error]).to eq('Correo ya registrado. Por favor intente con otro')
      end
    end
  end
end
