task remove_invalid_entries_report_cards_from_challenges: :environment do
  ReportCard.all.each do |r|
    if r.entry.invalid_entry?
      r.destroy
      print '.'
    end
  end
  puts ''
end
