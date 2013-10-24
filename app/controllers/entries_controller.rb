class EntriesController < ApplicationController


  def show
    @entry = Entry.find params[:id]
    @user = @entry.member
  end

  def new
    @challenge = Challenge.find params[:challenge_id]
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
    debugger
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

end

