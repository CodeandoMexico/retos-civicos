require 'spec_helper'

describe Location do
  describe 'search' do
    fixtures :locations
    describe 'given a valid zip code' do
      describe 'given the zip code has a locality' do
        it 'should return a hash with state, city, and locality' do
          expect(Location.search('64000').first.locality).to eq "Col. Centro"
        end
      end

      describe 'given the zip code does not have a locality' do
        it 'should return a hash with state, city, but no locality' do
          expect(Location.search('48400').first.locality).to eq nil
        end
      end
    end

    describe 'given a typod zip code' do
      it 'should return a fuzzy-searched result with the closest Locations' do
        expect(Location.search('48401').first.city).to eq("Tequila")
      end
    end
  end
end
