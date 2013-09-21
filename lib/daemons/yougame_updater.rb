#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

puts "== Updater started"
while($running) do
  Tracker.hanging.each{ |tracker| tracker.move_to_idle }
  Tracker.should_be_updated.each{ |tracker| tracker.make_update }
  sleep 60
end
