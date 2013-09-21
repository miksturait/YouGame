# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'secret'
    confirmed_at { Time.now }
    password_confirmation { password }
  end
end