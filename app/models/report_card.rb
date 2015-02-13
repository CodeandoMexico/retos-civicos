class ReportCard < ActiveRecord::Base
  attr_accessible :grades, :evaluation_id, :entry_id

  belongs_to :evaluation
  belongs_to :entry

  serialize :grades, Array
end
