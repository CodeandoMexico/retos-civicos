require 'spec_helper'

describe Dataset do

  describe "methods" do
    describe "#tokenizer_hash" do
      let(:guid) { "abcdguid" }
      let(:title) { "dataset1" }
      let!(:dataset) { FactoryGirl.create(:dataset, guid: guid, title: title) }

      it "it should return a hash with the guid and title" do
        expect(dataset.tokenizer_hash()).to eq({id: guid, title: title})
      end
    end
  end
end
