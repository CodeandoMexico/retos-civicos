module EntriesHelper
  def member_business(member)
    "Empresa: " + (member.company_name.present? ? "#{member.company_name}" : 'N/A')
  end

  def member_legal(member)
    "Representante: " + (member.company_president.present? ? "#{member.company_president}" : 'N/A')
  end

  def member_email(member)
    member.email.present? ? "#{member.email}" : 'N/A'
  end

end
