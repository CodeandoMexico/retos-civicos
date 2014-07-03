class Users::RegistrationsController < Devise::RegistrationsController
  layout 'aquila'

  after_filter :create_member_collaboration, only: :create

  def create_member_collaboration
    if current_member && Challenge.count == 1
      current_member.collaborations.create(challenge: last_challenge)
    end
  end
end
