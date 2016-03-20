require 'spec_helper'

describe Location do
  describe 'search' do
    fixtures :locations
    describe 'given a valid zip code' do
      describe 'given the zip code has a locality' do
        it 'should return a hash with state, city, and locality' do
          expect(Location.search('64000')).to eq [ locations(:location_with_locality) ]
        end
      end

      describe 'given the zip code does not have a locality' do
        it 'should return a hash with state, city, but no locality' do
          expect(Location.search('48400')).to eq [ locations(:location_without_locality) ]
        end
      end
    end

    describe 'given an invalid zip code' do
      it 'should return an empty hash' do
        expected_location = []
        expect(Location.search('48401')).to eq expected_location
      end
    end
  end
end
