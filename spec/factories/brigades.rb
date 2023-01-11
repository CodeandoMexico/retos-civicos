# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :brigade do
    description 'Bienvenido a la brigada de Monterrey! Come with us.'
    calendar_url 'https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics'
    slack_url 'https://codeandomexico.slack.com/messages/general'
    github_url 'https://github.com/CodeandoMexico'
    facebook_url 'https://www.facebook.com/CodeandoMexico'
    twitter_url 'https://twitter.com/codeandomexico'
    header_image_url 'http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png'
    association :user, name: 'Jacobo'
    association :location

    factory :brigade_with_users do
      new_users = [{ avatar: 'https://pbs.twimg.com/profile_images/451007105391022080/iu1f7brY.png', name: 'Barack Obama' },
                   { avatar: 'https://avatars1.githubusercontent.com/u/1312687?v=3&s=460', name: 'Adrian Rangel' },
                   { avatar: 'http://a4.files.biography.com/image/upload/c_fill,cs_srgb,dpr_1.0,g_face,h_300,q_80,w_300/MTMzMTE4ODA5NjE0NTkyNjQz.jpg', name: 'Enrique Nieto' }]

      after(:create) do |brigade, _evaluator|
        (0...new_users.length).each do |i|
          brigade.users << FactoryBot.create(:user, name: new_users[i][:name], avatar: new_users[i][:avatar])
        end
      end
    end
  end
end
