require 'spec_helper'

describe ApplicationController do

  describe '.edit_brigade_json' do
    describe 'when a valid brigade project id is given' do
      bp_with_tags = FactoryGirl.create(:brigade_project_with_tags, title: 'proj1')
      bp_without_tags = FactoryGirl.create(:brigade_project, title: 'proj2')

      it 'should return the respective brigade project' do
        edit_brigade_json_result = subject.edit_brigade_json(bp_with_tags)
        brigade_project_json = JSON.parse(edit_brigade_json_result[:brigade_project])
        expect(brigade_project_json['id']).to eq bp_with_tags.id
      end

      it 'should not raise an Invalid Brigade Project error' do
        expect { subject.edit_brigade_json(bp_with_tags) }.to_not raise_error Exceptions::InvalidBrigadeProjectError
      end

      it 'should have the translation for "update project" in current language' do
        edit_brigade_json_result = subject.edit_brigade_json(bp_with_tags)
        expected_button_text = I18n.t 'projects.update'
        expect(edit_brigade_json_result[:button_text]).to eq expected_button_text
      end

      it 'should have proper edit action link' do
        edit_brigade_json_result = subject.edit_brigade_json(bp_with_tags)
        expect(edit_brigade_json_result[:action_path]).to eq brigade_project_path(bp_with_tags)
      end

      describe 'when project has tags' do
        it 'should set an array of only those tags\' names' do
          edit_brigade_json_result = subject.edit_brigade_json(bp_with_tags)
          brigade_project_json = JSON.parse(edit_brigade_json_result[:brigade_project])
          expected_array = [{"name"=>"html"}, {"name"=>"scheme"}, {"name"=>"java"}]
          actual_array = brigade_project_json['tags']
          expect(array_of_hashes_equal?(actual_array, expected_array)).to eq true
        end
      end

      describe 'when project has no tags' do
        it 'should output an empty array' do
          edit_brigade_json_result = subject.edit_brigade_json(bp_without_tags)
          brigade_project_json = JSON.parse(edit_brigade_json_result[:brigade_project])
          expect(brigade_project_json['tags'].length).to eq 0
        end
      end
    end

    describe 'when an invalid brigade project is given' do
      it 'should raise an error' do
        expect { subject.edit_brigade_json('hi') }.to raise_error Exceptions::InvalidBrigadeProjectError
      end
    end
  end

end