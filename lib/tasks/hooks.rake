require "rake"
require "rake/hooks"

after 'db:migrate', 'db:schema:load' do
  ActiveRecord::Base.reload_views!
end
