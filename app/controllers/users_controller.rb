class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to challenges_path, notice: t('flash.users.updated')
    else
      render :edit
    end
  end

  def define_role
    @user = current_user
  end

  def set_role
    current_user.create_role(params)
    if current_user.update_attributes(params[:user])
      redirect_to edit_current_user_path(current_user.userable), notice: t('flash.users.welcome_and_edit_profile')
    else
      render :define_role 
    end
  end

end
