# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ehgp-info'
set :repo_url, 'https://github.com/abx-ea/ehgp-info.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/appl/apps/ehgp-info'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# RVM
set :rvm_type, :user
set :rvm_ruby_version, '2.2.3@ehgp-info'

# Bundler
set :bundle_jobs, 2

before 'deploy:finished', 'deploy:stop'
after 'deploy:finished', 'deploy:start'
