FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence() }
    body  { Faker::Lorem.sentence(3) }
  end

  factory :answer do
    body  { Faker::Lorem.sentence(3)}
    question
  end

  factory :user do
    username { Faker::Internet.user_name }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :vote do
    user
    answer
  end
end
