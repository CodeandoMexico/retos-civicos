class ReportCard < ActiveRecord::Base
  attr_accessible :entry_id, :evaluation_id, :grades

  belongs_to :evaluation
  belongs_to :entry

  def self.initialize_from_entries(evaluation, entries)
    raise evaluation.inspect
    entries.each do |entry|
      self.create(evaluation: evaluation, entry: entry, grades: evaluation.challenge.evaluation_criteria)
    end
  end
end
