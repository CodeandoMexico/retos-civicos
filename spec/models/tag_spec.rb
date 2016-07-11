require 'spec_helper'

RSpec.describe Tag, :type => :model do
  describe 'validations' do
    it 'should not allow empty name' do
      expect(FactoryGirl.build(:tag, name: '')).to_not be_valid
    end

    it 'should be valid if there is a name' do
      expect(FactoryGirl.build(:tag, name: 'HTML')).to be_valid
    end

    it 'should not allow tag names longer than 25 characters' do
      expect(FactoryGirl.build(:tag, name: 'abcdefghijklmnopqrstuvwxyz')).to_not be_valid
    end
  end

  describe '.create_tags_from_string' do
    let!(:single_tag_string) { "ruby" }
    let!(:multiple_tag_string) { "ruby,scheme,hello" }
    let!(:spaces_tag_string) { " ruby, scheme " }
    describe 'when there is only one tag' do
      let!(:split_tags_with_one_item) { Tag.create_tags_from_string(single_tag_string) }
      it 'should just create one Tag' do
        expect(split_tags_with_one_item.count).to eq 1
      end
      it 'the tag\'s name should be that of the string input' do
        expected_tags = ["ruby"]
        split_tags_contains_tag_names(expected_tags, split_tags_with_one_item)
      end
    end

    describe 'when there are more than one tags' do
      let!(:split_tags_with_multiple_item) { Tag.create_tags_from_string(multiple_tag_string) }
      it 'should create the same number of tags as commas +1' do
        expect(split_tags_with_multiple_item.count).to eq 3
      end
      it 'should contain the same names as the string input' do
        expected_tags = ["ruby", "scheme", "hello"]
        split_tags_contains_tag_names(expected_tags, split_tags_with_multiple_item)
      end

      describe 'when there are spaces at the beginning or end of the tags' do
        let!(:split_tags_with_spaces_item) { Tag.create_tags_from_string(spaces_tag_string) }
        it 'should return tags with trimmed names' do
          expected_tags = ["ruby", "scheme"]
          split_tags_contains_tag_names(expected_tags, split_tags_with_multiple_item)
        end
      end
    end

    describe 'when there are no tags' do
      it 'the array returned should be empty' do
        Tag.create_tags_from_string('')
      end
    end

    describe 'when a tag is passed that already exists' do
      let!(:split_tags_with_non_repeat_item) { Tag.create_tags_from_string(single_tag_string) }
      let!(:split_tags_with_repeat_item) { Tag.create_tags_from_string(multiple_tag_string) }
      it 'should create the same number of tags as number of unique name' do
        expect(split_tags_with_repeat_item.count).to eq 3
      end
      it 'should contain the same names as the string input ignoring duplicate names' do
        expected_tags = ["ruby", "scheme", "hello"]
        split_tags_contains_tag_names(expected_tags, split_tags_with_repeat_item)
      end
    end
  end
end
