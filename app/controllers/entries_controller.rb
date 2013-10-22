class EntriesController < ApplicationController

  def new
    @challenge = Challenge.find params[:challenge_id]
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

  def show
    @entry = Entry.find params[:id]
    @user = @entry.member
  end
end

