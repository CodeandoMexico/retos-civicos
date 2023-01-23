shared_context 'user logged in' do |valid_attributes|
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in user
    if (valid_attributes.present?)
      @valid_attributes_with_user = valid_attributes
      @valid_attributes_with_user[:user] = user
    end
  end
end
