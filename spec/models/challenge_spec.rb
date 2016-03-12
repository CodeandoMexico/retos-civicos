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

    describe '#total_references' do
      it 'returns the number of references on the challenge' do
        expect(active_ch.total_references).to eq(active_ch.references.size)
      end
    end

    describe '#is_active?' do
      it 'returns that an active challenege is active' do
        expect(active_ch.is_active?).to be_true
      end
    end

    describe '#has_started?' do
      it 'returns that a finished challenge has started' do
        expect(active_ch.has_started?).to be_true
      end
    end

    describe '#timeline_json' do
      it 'returns a JSON with all of the steps of the challenge' do
        timeline = active_ch.timeline_json
        expect(timeline['timeline'].count).to eq 5
      end
    end

    describe '#close_evaluation' do
      it 'should close the evaluations for the challenge' do
        expect(active_ch.evaluations_opened).to be_true
        active_ch.close_evaluation
        expect(active_ch.evaluations_opened).to be_false
      end
    end

    describe '#cancel!' do
      it 'should cancel the challenge' do
        expect(active_ch.status).to eq 'open'
        active_ch.cancel!
        expect(active_ch.status).to eq :cancelled
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

    describe '#auto_html' do
      it 'should embed a Youtube returns a list of challenges ordered by created date descending' do
        expect(Challenge.recent).to eq([cancelled_ch, finished_ch, working_on_ch,
                                        active_ch])
      end
    end

    describe '#create_or_update_datasets' do
      it 'should run without throwing errors' do
        active_ch.create_or_update_datasets
      end
    end

    describe '#remove_datasets' do
      it 'should run without throwing errors' do
        active_ch.remove_datasets
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
