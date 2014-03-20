require 'spec_helper'

describe Challenge do

  describe 'scopes' do
    let!(:active_ch) { FactoryGirl.create(:challenge) }
    let!(:working_on_ch) { FactoryGirl.create(:challenge, status: 'working_on') }
    let!(:finished_ch) { FactoryGirl.create(:challenge, status: 'finished') }
    let!(:cancelled_ch) { FactoryGirl.create(:challenge, status: 'cancelled') }

    describe '#active' do
      it 'returns a list of challenges with status open or working on' do
        expect(Challenge.active).to eq([active_ch, working_on_ch])
      end
    end

    describe '#inactive' do
      it 'returns a list of challenges with status finished or cancelled' do
        expect(Challenge.inactive).to eq([finished_ch, cancelled_ch])
      end
    end

    describe '#recent' do
      it 'returns a list of challenges ordered by created date descending' do
        expect(Challenge.recent).to eq([cancelled_ch, finished_ch, working_on_ch,
                                        active_ch])
      end
    end

    describe '#popular' do
      it 'returns a list of challenges ordered by the number of collaborations' do
        FactoryGirl.create_list(:collaboration, 3, challenge: finished_ch)
        FactoryGirl.create_list(:collaboration, 2, challenge: working_on_ch)
        FactoryGirl.create_list(:collaboration, 1, challenge: active_ch)
        expect(Challenge.popular).to eq([finished_ch, working_on_ch, active_ch, cancelled_ch])
      end
    end

  end

end
