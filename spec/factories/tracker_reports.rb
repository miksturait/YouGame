# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracker_report, :class => 'Tracker::Report' do
    tracker_id 1
    message "MyText"
    project_id 1
    creator_id 1
    report_date "2013-08-10 20:51:55"
  end
end
