set :application, 'mymapnow'
set :repository, 'gitosis@97.107.135.93:mymapnow.git'
set :deploy_to, "/home/webapps/#{application}"
set :web_command, 'sudo apache2ctl'
set :domain, 'webapps@97.107.135.93'

task :deploy => %w(
  vlad:update
  vlad:migrate
  vlad:start
  vlad:cleanup
)
