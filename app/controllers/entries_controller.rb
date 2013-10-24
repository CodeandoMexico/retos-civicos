class EntriesController < ApplicationController


  def show
    @entry = Entry.find params[:id]
    @user = @entry.member
  end

  def new
    @challenge = Challenge.find params[:challenge_id]
    redirect_if_has_submitted_app
    @entry = @challenge.entries.build
  end

  def edit
    @challenge = Challenge.find params[:challenge_id]
    @entry = Entry.find params[:id]
  end

  def create
    authorize! :create, Entry
		@challenge = Challenge.find(params[:challenge_id])
    @entry = @challenge.entries.build(params[:entry])
    if @entry.save
      redirect_to challenge_entry_path(@entry.challenge, @entry)
    else
      render :new
    end
  end

  def update
    @entry = Entry.find params[:id]
    authorize! :update, @entry
    if @entry.update_attributes(params[:entry])
      redirect_to challenge_entry_path(@entry.challenge, @entry)
    else
      render :edit
    end
  end

  private

  def redirect_if_has_submitted_app
    if current_user.has_submitted_app?(@challenge)
      redirect_to challenge_path(@challenge), notice: I18n.t("flash.unauthorized.already_submited_app")
    end
  end

end

