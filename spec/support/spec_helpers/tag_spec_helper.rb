module Helpers
  def split_tags_contains_tag_names(expected_tags, actual_tags)
    actual_tag_names = []
    actual_tags.each do |tag|
      actual_tag_names.push(tag.name)
    end
    expected_tags.each do |tag|
      expect(actual_tag_names).to include tag
    end
  end
end