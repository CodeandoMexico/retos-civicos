module Reportable
  include ActiveSupport::Concern

  def to_report
    self.class.report_attributes.map do |report_attribute|
      send(report_attribute).to_s
    end
  end

  module ClassMethods
    def self.report_attributes
      raise 'Not implemented'
    end
  end
end
