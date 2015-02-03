class ReportCard < ActiveRecord::Base
  attr_accessible :entry_id, :evaluation_id, :grades
end
