class UsersController < ApplicationController

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to challenges_path, notice: t('flash.users.updated')
    else
      render :edit
    end
  end

  def define_role
    @user = User.find(params[:id])
  end

  def set_role
    @user = User.find(params[:id])
    update_user_attributes
    if @user.organization?
      AdminMailer.notify_new_organization(@user).deliver
      redirect_to edit_user_path(@user), notice: t('auth_controller.welcome_new_org')
    else
      redirect_to challenges_path, notice: t('auth_controller.sign_in')
    end
  end

  private

  def update_user_attributes
    decode_role
    @user.email = params[:email]
    @user.save!
  end

  def decode_role
    validate_role
    if params[:commit] == 'Organizacion'
      @user.role = 'org'
    elsif params[:commit] == 'Participante'
      @user.role = 'member'
    end
  end

  def validate_role
    # Exception for preventing hacks on user role
    raise CanCan::AccessDenied if params[:commit] == 'admin'
  end

end
