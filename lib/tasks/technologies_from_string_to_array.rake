task technologies_from_string_to_array: :environment do
  Entry.all.each do |entry|
    if entry.technologies.is_a? String
      entry.technologies = entry.technologies.split(', ')
      entry.save
    end
  end
end
