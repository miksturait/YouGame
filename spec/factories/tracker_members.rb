# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracker_member, class: 'Tracker::Member' do
    login { Faker::Internet.user_name }
    full_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    skip_exists_check true
  end
end
