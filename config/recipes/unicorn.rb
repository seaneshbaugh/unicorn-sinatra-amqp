namespace :unicorn do
  %w[start stop restart].each do |command|
    desc "#{command.capitalize} unicorn"
    task command, roles: [:app] do
      run "#{shared_path}/scripts/unicorn #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
