require 'spec_helper'

feature 'User info configuration' do
	attr_reader :user

	before do
		@user = create :user
		sign_in_user(user, password: 'password')
		# puts @user.email
		# puts @user.password
	end

	scenario 'is redirected to edit page' do
		path = '/members/' + user.id.to_s + '/editar'
		current_path.should eq path
	end

	scenario 'able to change it\'s name' do
		fill_in 'member_name', with: 'Rafael Pérez'
		click_on 'Actualizar'
	end 

	scenario 'change it\'s bio with length < to 140 characters' do
		fill_in 'member_bio', with: %Q{
									Lorem ipsum dolor sit amet, 
									consectetur adipiscing elit. Sed id odio gravida, 
									facilisis nisl id, tempus nibh. Cras id lobortis est. 
									Mauris vulputate erat ac magna vestibulum.
									}
		click_on 'Actualizar'
		expect(page).not_to have_css('.errorExplanation')
	end 

	scenario 'NOT able to change it\'s bio with length > to 140 characters' do
		fill_in 'member_bio', with: %Q{
									Lorem ipsum dolor sit amet, 
									consectetur adipiscing elit. 
									Ut vulputate nec quam in fringilla. 
									Fusce nec gravida lacus. 
									Cras vitae nulla vitae est lacinia t
									incidunt vitae vitae risus. 
									Nulla ultrices urna diam, vel dignissim 
									sapien condimentum congue. Nunc cursus 
									enim vitae sapien ullamcorper consectetur. 
									Pellentesque gravida ornare nibh et iaculis. 
									Maecenas volutpat hendrerit accumsan. 
									Maecenas pellentesque felis ut dolor 
									molestie vulputate. Vivamus aliquet dolor tortor, 
									vitae iaculis nisi dignissim nec. Suspendisse 
									vehicula tellus ut purus porta, ut lacinia 
									odio cursus. Nunc in leo a ipsum varius 
									ultricies. Quisque ornare magna et leo euismod 
									ullamcorper id ac elit. Nulla sit amet 
									massa sem. Nunc et justo et urna semper 
									luctus id nec nisi. Integer tincidunt 
									varius sem sit amet laoreet. Aliquam 
									eu accumsan risus. Curabitur at faucibus purus. 
									Maecenas dolor ipsum, bibendum ut elit eu, 
									pretium malesuada augue. Nullam varius nisi 
									id mauris blandit, quis pretium nunc molestie. 
									In elementum nunc.									
									}
		click_on 'Actualizar'
		expect(page).to have_css('.errorExplanation')
	end

	scenario 'upload image file' do
		cmx_logo_path = Rails.root.join('app/assets/images/codeandomexico80.png')
		# cmx_logo_path = Rails.root.join('app/assets/javascripts/application.js')
		attach_file('member_avatar', cmx_logo_path)
		click_on 'Actualizar'
		expect(page).not_to have_css('.errorExplanation')
	end



end