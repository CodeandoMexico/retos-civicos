require 'spec_helper'

describe Brigade do

  describe '#num_members' do
    let!(:brigade_with_users) { FactoryGirl.create(:brigade_with_users) }

    it 'should return the number of followers + 1 for the organizer' do
      expect(brigade_with_users.num_members).to eq 4
    end

    describe 'no followers' do
      let!(:brigade) { FactoryGirl.create(:brigade) }

      it 'should return 1 for the organizer' do
        expect(brigade.num_members).to eq 1
      end
    end
  end

  describe '.search' do
    let!(:location1) { FactoryGirl.create(:location, city: "Tequila", state: "Jalisco") }
    let!(:location2) { FactoryGirl.create(:location, city: "Monterrey", state: "Nuevo León") }
    let!(:location3) { FactoryGirl.create(:location, city: "Mazatlan", state: "Sinaloa") }
    let!(:brigade) { FactoryGirl.create(:brigade_with_users, location: location1) }
    let!(:brigade) { FactoryGirl.create(:brigade, location: location2) }
    let!(:brigade) { FactoryGirl.create(:brigade, location: location3) }

    it 'should return the brigades that match the search query' do
      pending
      result = Brigade.search("Tequila")
      expect(result.length).to eq 1
      expect(result.first[:city]).to eq "Tequila"
      expect(result.first[:state]).to eq "Jalisco"
      expect(results.first[:members].length).to eq 3
      expect(result.first[:members].pluck(:name)).to include "Barack Obama"
      expect(result.first[:members].pluck(:name)).to include "Adrian Rangel"
      expect(result.first[:members].pluck(:name)).to include "Enrique Nieto"
    end
  end

  describe '#followers' do
    let!(:brigade_with_users) { FactoryGirl.create(:brigade_with_users) }

    it 'should return relation of the brigades followers whom are of type Users' do
      expect(brigade_with_users.followers.pluck(:name)).to include "Barack Obama"
      expect(brigade_with_users.followers.pluck(:name)).to include "Adrian Rangel"
      expect(brigade_with_users.followers.pluck(:name)).to include "Enrique Nieto"
    end

    it 'should only return User objects' do
      expect(brigade_with_users.followers).to all(be_a_kind_of User)
    end

    it 'should not include the organizer' do
      expect(brigade_with_users.followers.pluck(:name)).to_not include "Jacobo"
    end

    describe 'no followers' do
      let!(:brigade) { FactoryGirl.create(:brigade) }

      it 'should return an empty relation' do
        expect(brigade.followers.size).to be 0
      end
    end
  end

  describe '#organizer' do
    let!(:brigade) { FactoryGirl.create(:brigade) }

    it 'should return the owner of the brigade' do
      expect(brigade.organizer.name).to eq "Jacobo"
    end

    it 'should be a User' do
      expect(brigade.organizer).to be_a_kind_of User
    end

    describe "with followers" do
      let!(:brigade_with_users) { FactoryGirl.create(:brigade_with_users) }

      it 'should be independent from the existence of followers' do
        expect(brigade_with_users.organizer.name).to eq "Jacobo"
      end
    end
  end

  describe 'Given a valid brigade was created' do
    let!(:brigade) { FactoryGirl.create(:brigade) }

    it 'should reference a location' do
      expect(brigade.location).to_not be_nil
      expect(brigade.location).to be_an_instance_of Location
      expect(brigade.location.zip_code).to eq "45050"
    end

    it 'should reference a user' do
      expect(brigade.user).to_not be_nil
      expect(brigade.user).to be_an_instance_of User
      expect(brigade.user.name).to eq "Jacobo"
    end

    it 'should have a description if one was given' do
      expect(brigade.description).to_not be_nil
      expect(brigade.description).to eq "Bienvenido a la brigada de Monterrey! Come with us."
    end

    it 'should have a calendar url if one was given' do
      cal_url = "https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics"
      expect(brigade.calendar_url).to eq cal_url
    end

    it 'should have a slack url if one was given' do
      expect(brigade.slack_url).to eq "https://codeandomexico.slack.com/messages/general"
    end

    it 'should have a facebook url if one was given' do
      expect(brigade.facebook_url).to eq "https://www.facebook.com/CodeandoMexico"
    end

    it 'should have a github url if one was given' do
      expect(brigade.github_url).to eq "https://github.com/CodeandoMexico"
    end

    it 'should have a twitter url if one was given' do
      expect(brigade.twitter_url).to eq "https://twitter.com/codeandomexico"
    end

    it 'should have a header image url if one was given' do
      expect(brigade.header_image_url).to eq "http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png"
    end

    it 'should default deactived to false' do
      expect(brigade.deactivated).to be_falsey
    end
  end

  describe 'Given an invalid brigade was created' do
    describe 'location' do
      describe 'Given the brigade has no location' do
        let(:brigade_without_location) { FactoryGirl.build(:brigade, location: nil) }

        it 'should should not be valid' do
          expect(brigade_without_location).to_not be_valid
        end
      end
    end

    describe 'user' do
      describe 'Given the brigade has no user' do
        let(:brigade_without_user) { FactoryGirl.build(:brigade, user: nil) }

        it 'should should not be valid' do
          expect(brigade_without_user).to_not be_valid
        end
      end
    end
    describe 'description' do
      describe 'Given the description is too long' do
        let(:brigade_with_long_description) { FactoryGirl.build(:brigade, description: "A"*501) }

        it 'should should not be valid' do
          expect(brigade_with_long_description).to_not be_valid
        end
      end
    end

    describe 'calendar_url' do
      describe 'Given the calendar URL is too long' do
        let(:brigade_with_long_calendar_url) { FactoryGirl.build(:brigade, calendar_url: "A"*501) }

        it 'should should not be valid' do
          expect(brigade_with_long_calendar_url).to_not be_valid
        end
      end

      describe 'Given the calendar URL is not valid URL' do
        let(:brigade_with_invalid_calendar_url) { FactoryGirl.build(:brigade, calendar_url: "A"*50) }

        it 'should should not be valid' do
          expect(brigade_with_invalid_calendar_url).to_not be_valid
        end
      end

      # describe 'Given the calendar URL is not a valid Google Calendar' do
      #   let(:brigade_with_invalid_calendar_url) { FactoryGirl.build(:brigade, calendar_url: "http://google.com") }
      #
      #   it 'should not be valid' do
      #     pending 'Do not know how to validate calendars yet. Fix when working on Calendar sprint'
      #     expect(brigade_with_invalid_calendar_url).to_not be_valid
      #   end
      # end
    end

    describe 'slack_url' do
      describe 'Given the slack URL is too long' do
        let(:brigade_with_long_slack_url) { FactoryGirl.build(:brigade, slack_url: "A"*67) }

        it 'should not be valid' do
          expect(brigade_with_long_slack_url).to_not be_valid
        end
      end

      describe 'Given the slack URL is not valid URL' do
        let(:brigade_with_invalid_slack_url) { FactoryGirl.build(:brigade, slack_url: "A"*50) }

        it 'should should not be valid' do
          expect(brigade_with_invalid_slack_url).to_not be_valid
        end
      end

      describe 'Given the slack URL is not a valid Slack URL' do
        let(:brigade_with_invalid_slack_url) do
          FactoryGirl.build(:brigade, slack_url: "http://iamover21charssoiaminvalid.slack.com")
        end

        it 'should should not be valid' do
          expect(brigade_with_invalid_slack_url).to_not be_valid
        end
      end
    end

    describe 'facebook_url' do
      describe 'Given the facebook URL is too long' do
        let(:brigade_with_long_facebook_url) { FactoryGirl.build(:brigade, facebook_url: "A"*501) }

        it 'should not be valid' do
          expect(brigade_with_long_facebook_url).to_not be_valid
        end
      end

      describe 'Given the facebook URL is not valid URL' do
        let(:brigade_with_invalid_facebook_url) { FactoryGirl.build(:brigade, facebook_url: "A"*50) }

        it 'should should not be valid' do
          expect(brigade_with_invalid_facebook_url).to_not be_valid
        end
      end

      describe 'Given the facebook URL is not a valid Facebook URL' do
        let(:brigade_with_invalid_facebook_url) do
          FactoryGirl.build(:brigade, facebook_url: "http://facebook.com")
        end

        it 'should should not be valid' do
          expect(brigade_with_invalid_facebook_url).to_not be_valid
        end
      end
    end

    describe 'github_url' do
      describe 'Given the github URL is too long' do
        let(:brigade_with_long_github_url) { FactoryGirl.build(:brigade, github_url: "A"*501) }

        it 'should not be valid' do
          expect(brigade_with_long_github_url).to_not be_valid
        end
      end

      describe 'Given the github URL is not valid URL' do
        let(:brigade_with_invalid_github_url) { FactoryGirl.build(:brigade, github_url: "A"*50) }

        it 'should should not be valid' do
          expect(brigade_with_invalid_github_url).to_not be_valid
        end
      end

      describe 'Given the github URL is not a valid Github URL' do
        let(:brigade_with_invalid_github_url) do
          FactoryGirl.build(:brigade, github_url: "http://facebook.com/")
        end

        it 'should should not be valid' do
          expect(brigade_with_invalid_github_url).to_not be_valid
        end
      end
    end

    describe 'twitter_url' do
      describe 'Given the twitter URL is too long' do
        let(:brigade_with_long_twitter_url) { FactoryGirl.build(:brigade, twitter_url: "A"*501) }

        it 'should not be valid' do
          expect(brigade_with_long_twitter_url).to_not be_valid
        end
      end

      describe 'Given the twitter URL is not valid URL' do
        let(:brigade_with_invalid_twitter_url) { FactoryGirl.build(:brigade, twitter_url: "A"*50) }

        it 'should should not be valid' do
          expect(brigade_with_invalid_twitter_url).to_not be_valid
        end
      end

      describe 'Given the twitter URL is not a valid Twitter URL' do
        let(:brigade_with_invalid_twitter_url) do
          FactoryGirl.build(:brigade, twitter_url: "http://twitter.com/")
        end

        it 'should should not be valid' do
          expect(brigade_with_invalid_twitter_url).to_not be_valid
        end
      end
    end

    describe 'header_image_url' do
      describe 'Given the header_image URL is too long' do
        let(:brigade_with_long_header_image_url) { FactoryGirl.build(:brigade, header_image_url: "A"*501) }

        it 'should not be valid' do
          expect(brigade_with_long_header_image_url).to_not be_valid
        end
      end

      describe 'Given the image header URL is not valid URL' do
        let(:brigade_with_invalid_header_image_url) { FactoryGirl.build(:brigade, header_image_url: "A"*50) }

        it 'should should not be valid' do
          expect(brigade_with_invalid_header_image_url).to_not be_valid
        end
      end

      describe 'Given the header image URL is not a valid image URL' do
        let(:brigade_with_invalid_header_image_url) do
          FactoryGirl.build(:brigade, header_image_url: "http://facebook.com/")
        end

        it 'should should not be valid' do
          expect(brigade_with_invalid_header_image_url).to_not be_valid
        end
      end
    end

    describe 'deactivated' do
      describe 'should be a boolean' do
        let(:brigade_with_invalid_deactivated) { FactoryGirl.build(:brigade, header_image_url: "A") }

        it 'should should not be valid' do
          expect(brigade_with_invalid_deactivated).to_not be_valid
        end
      end
    end
  end
end
