class ReportCard < ActiveRecord::Base
  attr_accessible :grades, :evaluation, :entry

  belongs_to :evaluation
  belongs_to :entry
end
