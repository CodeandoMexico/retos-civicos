require 'spec_helper'

describe Brigade do
  describe 'location_of_zip_code' do
    describe 'given a valid zip code' do
      describe 'given the zip code has a locality' do
        it 'should return a hash with state, city, and locality' do
          expected_location = { 'state' => 'Nuevo León', 'city' => 'Monterrey', 'locality' => 'Col. Centro' }
          expect(Brigade.location_of_zip_code('64000')).to eq expected_location
        end
      end

      describe 'given the zip code does not have a locality' do
        it 'should return a hash with state, city, but no locality' do
          expected_location = { 'state' => 'Jalisco', 'city' => 'Tequila' }
          expect(Brigade.location_of_zip_code('48400')).to eq expected_location
        end
      end
    end

    describe 'given an invalid zip code' do
      it 'should return an empty hash' do
        expected_location = {}
        expect(Brigade.location_of_zip_code('48401')).to eq expected_location
      end
    end
  end
end
