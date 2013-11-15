server '10.50.50.137', :app, :web, :db, primary: true

set :branch, defer { 'master' }
set :sinatra_env, defer { 'production' }
