task live_demo_url_to_idea_url: :environment do
  Entry.find_each do |entry|
    entry.update_column(:idea_url, entry.live_demo_url)
  end
end
