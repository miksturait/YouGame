# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracker_project, class: 'Tracker::Project' do
    name {Faker::Company.name}
    project_id {Faker::Lorem.word}
  end
end
