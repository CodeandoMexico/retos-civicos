require 'spec_helper'

describe 'Brigades' do
  describe 'GET /brigades' do
    it 'works! (now write some real specs)' do
      user = FactoryBot.create(:user)
      user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      login_as(user, scope: :user, run_callbacks: false)
      get brigades_path
      response.status.should be(200)
    end
  end
end
