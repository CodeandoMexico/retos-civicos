module EntriesHelper
  def member_email(member)
    member.email.present? ? member.email.to_s : 'N/A'
  end
end
