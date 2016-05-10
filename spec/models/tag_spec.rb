require 'spec_helper'

RSpec.describe Tag, :type => :model do
  describe 'validations' do
    it 'should not allow empty name' do
      expect(FactoryGirl.build(:tag, name: '')).to_not be_valid
    end

    it 'should be valid if there is a name' do
      expect(FactoryGirl.build(:tag, name: 'HTML')).to be_valid
    end
  end
end
