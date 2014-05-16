module SessionHelpers
  def sign_in_user(user, opts = {})
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: opts.fetch(:password) { 'password' }
    click_button 'Entrar'
  end

  def sign_in_organization_admin(organization_admin)
    visit new_user_session_path
    fill_in 'user[email]', with: organization_admin.email
    fill_in 'user[password]', with: 'password'
    click_button 'Entrar'
  end
end
