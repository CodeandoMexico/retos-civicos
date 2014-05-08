require 'spec_helper'

feature 'User info configuration' do
	attr_reader :user
	attr_reader :organization

	before do
		@user = create :user
		@organization = create :organization
		puts @user.name
		puts @user.email
		puts @user.nickname
		puts @user.password

		sign_in_user(user, password: 'password')
		# sign_in_organization_admin(organization)
	end

	# attr_reader :organization
	# before do
	# 	@organization = create :organization
	# 	puts @organization.name
	# 	puts @organization.email
	# end

	scenario 'User should be able to update it\'s information' do

	end
end