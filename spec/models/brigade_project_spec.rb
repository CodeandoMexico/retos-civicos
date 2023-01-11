require 'spec_helper'

RSpec.describe BrigadeProject, :type => :model do
  describe 'validations' do
    it 'should not allow empty titles' do
      expect(FactoryBot.build(:brigade_project_with_tags, title: '')).to_not be_valid
    end

    it 'should allow lack of tags' do
      expect(FactoryBot.build(:brigade_project_with_tags)).to be_valid
    end

    it 'should allow empty description' do
      expect(FactoryBot.build(:brigade_project_with_tags, 'description' => '')).to be_valid
    end
  end

  describe '.most_relevant' do
    describe 'when there are more than three projects for a particular brigade' do
      it 'returns at most three projects' do
        bp1 = FactoryBot.create(:brigade_project_with_tags, title: 'proj1')
        bp2 = FactoryBot.create(:brigade_project_with_tags, title: 'proj2')
        bp3 = FactoryBot.create(:brigade_project_with_tags, title: 'proj3')
        bp4 = FactoryBot.create(:brigade_project_with_tags, title: 'proj4')
        bp5 = FactoryBot.create(:brigade_project_with_tags, title: 'proj5')
        projects = [bp1, bp2, bp3, bp4, bp5]
        most_relevant = BrigadeProject.most_relevant(1)
        expect(most_relevant.count).to eq 3
        relevant_project_ids = most_relevant.pluck(:id)
        count = 0
        projects.each do |project|
          count += 1 if relevant_project_ids.include? project.id
        end
        expect(count).to eq(3)
      end
    end

    describe 'when there are projects from multiple brigades' do
      it 'returns only projects from the current brigade' do
        bp1 = FactoryBot.create(:brigade_project_with_tags, title: 'proj1', brigade_id: 1)
        bp2 = FactoryBot.create(:brigade_project_with_tags, title: 'proj2', brigade_id: 2)
        bp3 = FactoryBot.create(:brigade_project_with_tags, title: 'proj3', brigade_id: 1)
        bp4 = FactoryBot.create(:brigade_project_with_tags, title: 'proj4', brigade_id: 2)
        bp5 = FactoryBot.create(:brigade_project_with_tags, title: 'proj5', brigade_id: 1)
        bp6 = FactoryBot.create(:brigade_project_with_tags, title: 'proj6', brigade_id: 3)
        extra_projects = [bp2, bp4, bp6]
        most_relevant = BrigadeProject.most_relevant(1)
        expect(most_relevant.count).to eq 3
        relevant_project_ids = most_relevant.pluck(:id)
        extra_projects.each do |project|
          expect(relevant_project_ids.include? project.id).to be_falsey
        end
      end
    end

    describe 'when there are less than three projects for a particular brigade' do
      it 'returns all projects' do
        bp1 = FactoryBot.create(:brigade_project_with_tags, title: 'proj1')
        bp2 = FactoryBot.create(:brigade_project_with_tags, title: 'proj2')
        projects = [bp1, bp2]
        most_relevant = BrigadeProject.most_relevant(1)
        expect(most_relevant.count).to eq 2
        relevant_project_ids = most_relevant.pluck(:id)
        projects.each do |project|
          expect(relevant_project_ids.include? project.id).to be_truthy
        end
      end
    end

    describe 'when there are no projects for a particular brigade' do
      it 'returns all projects' do
        FactoryBot.create(:brigade_project_with_tags, title: 'proj1', brigade_id: 2)
        most_relevant = BrigadeProject.most_relevant(1)
        expect(most_relevant.count).to eq 0
      end
    end
  end

  describe '#tag_names' do
    describe 'when there are tags for multiple projects' do
      tag_set_1 = ['kyle', 'allen', 'boss']
      tag_set_2 = ['hello', 'my', 'name']
      bp1 = FactoryBot.create(:brigade_project_with_tags, brigade_id: 1, given_tags: tag_set_1)
      bp2 = FactoryBot.create(:brigade_project_with_tags, brigade_id: 2, given_tags: tag_set_2)
      tag_names = bp1.tag_names

      it 'should return the same number of tags as the number of tags that exist for the project' do
        expect(tag_names.count).to eq 3
      end

      it 'should only return tag names for the current project' do
        tag_set_1.each do |tag|
          expect(tag_names).to include tag
        end
      end
    end

    describe 'when there are no tags for the current project' do
      it 'should declare that no tag names exist' do
        tag_set = ['hello', 'my', 'name']
        bp1 = FactoryBot.create(:brigade_project, brigade_id: 1)
        bp2 = FactoryBot.create(:brigade_project_with_tags, brigade_id: 2, given_tags: tag_set)
        tag_names = bp1.tag_names
        expect(tag_names.count).to eq 0
      end
    end
  end
end
