class PrototypesController < ApplicationController
  layout 'aquila'

  def new
    entry
  end

  def create
    challenge
    entry
    if entry_params && entry.update_attributes(entry_params)
      redirect_to challenge_path(challenge), notice: Phases.prototype_added_message(challenge)
    else
      render :new
    end
  end

  def edit
    entry
  end

  def update
    challenge
    entry
    if entry_params && entry.update_attributes(entry_params)
      redirect_to challenge_path(challenge), notice: Phases.prototype_edited_message(challenge)
    else
      redirect_to edit_challenge_prototype_path(challenge)
      # render :edit
    end
  end

  private

  def challenge
    @challenge ||= Challenge.find(params[:challenge_id])
  end

  def entry
    @entry ||= current_member.entry_for(challenge)
  end

  def entry_params
    prototype = params[:entry].slice(:repo_url, :demo_url)
    return prototype if prototype[:repo_url].present? && prototype[:demo_url].present?
  end
end
