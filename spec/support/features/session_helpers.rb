module SessionHelpers
  def sign_in_user(user, opts={})
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: opts[:password]
    click_button 'Entrar'
  end
end


