task "jobs:work" => :environment do
  Rake::Task["resque:work"].invoke
  Rake::Task["daemons:stop"].invoke
  Rake::Task["daemons:start"].invoke
end