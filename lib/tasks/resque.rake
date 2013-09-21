require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = 'yougame_install,yougame_update,yougame_broadcast'
  Resque.before_fork = proc{ ActiveRecord::Base.establish_connection }
end