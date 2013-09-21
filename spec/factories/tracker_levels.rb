# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracker_level, :class => 'Tracker::Level' do
    planet_name "MyString"
    brood_name "MyString"
    mineral_name "MyString"
    month "MyString"
    tracker_id 1
    target 1
    completed_at "2013-04-26 15:56:18"
  end
end
