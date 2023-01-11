require 'spec_helper'

describe Skill do
  describe 'methods' do
    describe '.find_or_create_by_name' do
      let(:existing_skill_name) { 'Ruby' }
      let(:new_skill_name) { 'Java' }
      let!(:skill) { FactoryBot.create(:skill, name: existing_skill_name) }

      describe 'given skill is present' do
        it 'then it should not create a new skill' do
          expect { Skill.find_or_create_by_name(existing_skill_name) }.to change(Skill, :count).by(0)
        end
        it 'then it should return the existing skill' do
          expect(Skill.find_or_create_by_name(existing_skill_name).name).to eq existing_skill_name
        end
      end

      describe 'given skill is not present' do
        it 'then it should create a new skill' do
          expect { Skill.find_or_create_by_name(new_skill_name) }.to change(Skill, :count).by(1)
        end
        it 'then it should return the new skill' do
          expect(Skill.find_or_create_by_name(new_skill_name).name).to eq new_skill_name
        end
      end
    end
  end
end
