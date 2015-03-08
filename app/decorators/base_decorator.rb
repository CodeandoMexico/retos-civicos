class BaseDecorator < SimpleDelegator
  def component
    @component ||= __getobj__
  end

  def helper
    @helper ||= ApplicationController.helpers
  end

  def class
    component.class
  end
end
