class Users::RegistrationsController < Devise::RegistrationsController
  layout 'aquila'

  after_filter :create_member_collaboration, only: :create

  def create_member_collaboration
    Collaborations.create_after_registration(current_member)
  end
end
