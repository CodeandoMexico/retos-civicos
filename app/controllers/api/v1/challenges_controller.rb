module Api
  module V1
    class ChallengesController < ApplicationController
      def index
        render json: challenges
      end

      private

      def challenges
        if organization_id = params[:organization_id]
          Challenge.where(organization_id: organization_id)
        else
          Challenge.all
        end
      end
    end
  end
end
