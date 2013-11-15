namespace :amqp_worker do
  desc 'Stop the amqp_worker process'
  task :stop, roles: :app do
    run "cd #{current_path}; bin/amqp_worker stop"
  end
  after 'deploy:stop', 'amqp_worker:stop'

  desc 'Start the amqp_worker process'
  task :start, roles: :app do
    run "cd #{current_path}; bin/amqp_worker start"
  end
  after 'deploy:start', 'amqp_worker:start'

  desc 'Restart the amqp_worker process'
  task :restart, roles: :app do
    run "cd #{current_path}; bin/amqp_worker restart"
  end
  after 'deploy:restart', 'amqp_worker:restart'
end
