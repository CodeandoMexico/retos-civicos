require 'spec_helper'

module Api
  module V1
    describe ChallengesController do
      describe 'GET index' do
        it 'returns all the challenges' do
          challenge = create :challenge

          get :index, locale: 'en'
          JSON.parse(response.body).should eq JSON.parse([challenge.as_json].to_json)
        end

        describe 'with :organization_id' do
          it 'returns all the challenges of the organization' do
            challenge = create :challenge
            other_challenge = create :challenge

            get :index, organization_id: challenge.organization_id, locale: 'en'
            JSON.parse(response.body).should eq JSON.parse([challenge.as_json].to_json)
          end
        end
      end

      def parsed_response
        JSON.parse(response.body)
      end
    end
  end
end
