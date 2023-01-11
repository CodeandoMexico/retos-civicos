class Member < ActiveRecord::Base
  include Reportable

  acts_as_user
  paginates_per 21
  has_many :collaborations
  has_many :challenges, through: :collaborations
  has_many :entries

  def self.report_attributes
    [:id, :name, :email, :created_at]
  end

  def to_s
    return name unless name.blank?
    return nickname unless nickname.blank?
    ''
  end

  def to_param
    "#{id}-#{to_s.parameterize}"
  end

  def representative
    # to-do clean this a little bit and merge with to_s
    case
    when name.present? then name
    when nickname.present? then nickname
    else ''
    end
  end

  def able_to_edit_entry?(challenge)
    submitted_app?(challenge) && Phases.current?(:ideas, challenge)
  end

  def able_to_submit_a_prototype?(challenge)
    submitted_app?(challenge) && entry_has_been_accepted?(challenge) && Phases.current?(:prototypes, challenge)
  end

  def entry_has_been_accepted?(challenge)
    entry_for(challenge).accepted?
  end

  def submitted_app?(challenge)
    !entry_for(challenge).nil?
  end

  def submitted_prototype_for_challenge?(challenge)
    entry = entry_for(challenge)
    return false unless entry.present?
    entry.repo_url.present? && entry.demo_url.present?
  end

  def entry_for(challenge)
    userable.entries.where(challenge_id: challenge.id).first
  end
end
