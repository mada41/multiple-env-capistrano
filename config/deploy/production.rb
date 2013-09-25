# SERVERS
role :web, "pricehub.com"
role :app, "pricehub.com"
role :db, "pricehub.com", :primary => true  # This is where Rails migrations will run


# server "pricehub.com", :web, :app, :db, :primary => true


# GIT
set :branch, 'master'

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