# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brigade do
    zip_code "66603"
    city "Monterrey"
    state "Nuevo Leon"
    description "Bienvenido a la brigada de Monterrey! Come with us."
    calendar_url "https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics"
    slack_url "https://codeandomexico.slack.com/messages/general"
    github_url "https://github.com/CodeandoMexico"
    facebook_url "https://www.facebook.com/CodeandoMexico"
    twitter_url "https://twitter.com/codeandomexico"
    header_image_url "http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png"
    user association :user, name: 'Jacobo'
    deactivated false
  end
end
