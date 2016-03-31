require 'spec_helper'

describe Location do
  describe 'search' do
    fixtures :locations
    describe 'given a valid query' do
      describe 'given the search result has a locality' do
        it 'should return a hash with state, city, and locality' do
          expect(Location.search('64000').first.locality).to eq "Col. Centro"
        end
      end

      describe 'given the search result does not have a locality' do
        it 'should return a hash with state, city, but no locality' do
          expect(Location.search('48400').first.locality).to eq nil
        end
      end

      describe 'given the search query uses accents' do
        it 'should return results independent if accents are used' do
          pending 'Not quite sure how to make it accent independent without affecting UX. Not a big deal in meantime.'
          expect(Location.search('León').length).to eq 1
          expect(Location.search('Leon').length).to eq 1
        end
      end

      describe 'given the search query uses weird caps' do
        it 'should return results independent of query case' do
          expect(Location.search('NUEVO LEON').length).to eq 1
        end
      end

      describe 'given the search matches several locations with the same city & state' do
        it 'should only return one of the locations' do
          expect(Location.search('Nuevo Leon').length).to eq 1
        end

        it 'should return at most 5 results' do
          expect(Location.search('Jalisco').length).to eq 5
        end
      end

      describe 'given the search query includes a typo' do
        describe 'given an incomplete zip code' do
          it 'should return a fuzzy-searched result with the most relevant locations' do
            expect(Location.search('48401').first.city).to eq("Tequila")
          end
        end

        describe 'given a incorrectly typed city or state' do
          it 'should return a fuzzy-searched result with the most relevant Locations' do
            expect(Location.search('Teqilaa').first.city).to eq("Tequila")
          end
        end
      end

      describe 'given the search is empty' do
        it 'should return nil' do
          expect(Location.search('')).to eq nil
        end
      end
    end
  end
end
