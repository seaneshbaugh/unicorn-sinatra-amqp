set :stages, %w(production)
set :default_stage, 'production'

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', 'rvm:create_gemset'

require 'rvm/capistrano'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :use_sudo, false
set :user, 'deployer'
set :deploy_via, :remote_cache

set :application, 'newsletter'

set :copy_exclude, %w(
.git .gitignore
unicorn.conf
README.md
)

set :scm, 'git'
set :repository, 'git@github.com:seaneshbaugh/unicorn-sinatra-amqp.git'
set (:branch) { branch }
set :scm_verbose, true

set (:deploy_to) { "/home/#{user}/sites/#{application}" }

load 'config/recipes/check'
load 'config/recipes/symlinks'
load 'config/recipes/unicorn'

after 'deploy', 'deploy:cleanup'
