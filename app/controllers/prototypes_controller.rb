class PrototypesController < ApplicationController
  layout 'aquila'
  before_filter :load_entry

  def new
  end

  def create
    if valid_entry_params?
      entry.update_attributes(entry_params)
      redirect_to challenge_path(challenge), notice: Phases.prototype_added_message(challenge)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if valid_entry_params?
      entry.update_attributes(entry_params)
      redirect_to challenge_path(challenge), notice: Phases.prototype_edited_message(challenge)
    else
      render :edit
    end
  end

  private

  def challenge
    @challenge ||= Challenge.find(params[:challenge_id])
  end

  def entry
    @entry ||= current_member.entry_for(challenge)
  end

  alias_method :load_entry, :entry

  def entry_params
    params[:entry].slice(:repo_url, :demo_url)
  end

  def valid_entry_params?
    entry_params[:repo_url].present? && entry_params[:demo_url].present?
  end
end
