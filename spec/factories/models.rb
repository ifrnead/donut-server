require 'faker'

FactoryGirl.define do
  factory :message do
    content { Faker::HowIMetYourMother.quote }
    association :user, factory: :user
    association :room, factory: :room
  end

  factory :room do
    suap_id 1
    year 65
    semester 1
    curricular_component "Teste - Teste - Teste"
  end

  factory :user do
    email { Faker::Internet.email }
    password Rails.application.secrets.username
    username Rails.application.secrets.password
    current_suap_token { Faker::Crypto.sha256 }
    suap_token_expiration_time { DateTime.now + 1 }
    suap_id 1
    enroll_id 1
    name { Faker::HowIMetYourMother.character }
    fullname { Faker::HowIMetYourMother.character }
    category "Docente"
    url_profile_pic "fotos/profile.jpg"
  end

  factory :subscription do
    association :user, factory: :user
    association :room, factory: :room
  end
end
