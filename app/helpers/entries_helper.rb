module EntriesHelper
  def member_email(member)
    member.email.present? ? "#{member.email}" : 'N/A'
  end
end
