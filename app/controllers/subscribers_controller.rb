class SubscribersController < ApplicationController

  def create
    organization = Organization.find(params[:organization_id])
    @subscriber = organization.subscribers.new(email: params[:email])
    if @subscriber.save
      redirect_to organization, notice: t('flash.organizations.welcome_new_subscriber')
    else
      redirect_to organization, flash: { error: t('flash.organizations.repeated_subscriber') }
    end
  end

end
