# SERVERS
role :web, "dev1.pricehub.com"
role :app, "dev1.pricehub.com"
role :db, "dev1.pricehub.com", :primary => true  # This is where Rails migrations will run

# server "dev1.pricehub.com", :web, :app, :db, :primary => true

# GIT
set :branch, 'development' # i think we must have different branch for development too

# WHENEVER
# require "whenever/capistrano"
# set :whenever_command, "bundle exec whenever"
# set :whenever_roles, ['app']

# before 'deploy:assets:precompile' do
# end

# after 'deploy:setup' do
# end

# after 'deploy' do
# end

require "rvm/capistrano"
