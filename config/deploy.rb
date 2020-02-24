# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, 'hackr.tv'
set :repo_url, "git@github.com:TheCyberpulse/hackr.tv.git"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, "/var/www/hackr.tv"
append :linked_files, 'config/application.yml'
set :keep_releases, 5
set :ssh_options, { :forward_agent => true }
