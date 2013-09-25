require "bundler/capistrano"
require './config/boot'
require 'capistrano/ext/multistage'
load "deploy/assets"

set :stages, %w(development production)
set :default_stage, "development"

# GENERAL
set :user, "root"
set :runner, "deploy"
set :use_sudo, false
set :password, "" # password for remote server
set :domain, "" #domain name
set :application, "pricehub" # app name
set :repository,  "git@bitbucket.org:myronlo/pricehub.com.git" #repository url
set :application_dir, "/home/#{user}/rails_app/#{application}/production" # application directory


# GIT
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :keep_releases, 3
set :deploy_to, application_dir
set :deploy_via, :export

# SSH
default_run_options[:pty] = true
ssh_options[:paranoid] = true # comment out if it gives you trouble. newest net/ssh needs this set.

# Custom Tasks
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
end

namespace :db do
  task :db_config, :role => :app, :except => { :no_release => true } do
    run "cp -f #{application_dir}/shared/database/database.yml #{release_path}/config/database.yml"
  end
end

namespace :logs do
  desc "tail production log files"
  task :tail, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end

  desc "copy production log"
  task :copy_log, :role => :app, :except => { :no_release => true } do
    run "ln -s #{application_dir}/shared/log/production.log #{release_path}/log/production.log"
  end
end

######## Callbacks - No More Config ########
after "deploy:restart", "deploy:cleanup"
after "deploy:update_code", "deploy:migrate"
after "deploy:finalize_update", "db:db_config"
