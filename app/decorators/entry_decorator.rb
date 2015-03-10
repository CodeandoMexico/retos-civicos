class EntryDecorator < BaseDecorator
  def owner_name
    if member.company_name.present?
      member.company_name
    elsif member.name.present?
      member.name
    else
      member.email
    end
  end
end
