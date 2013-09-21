# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracker do
    url 'http://example.com/youtrack'
    username 'youGameObserver'
    password 'alj0gh2xltdw1nopqp2l'
    issue_accepted_state 'Fixed,Verified'
    issue_backlog_state 'Submitted'
    issue_in_progress_state 'In Progress'
    role_name 'youGame observers'
    issue_difficulty_field 'Difficulty'
    admin_username 'administrator'
    admin_password 'password'
  end
end