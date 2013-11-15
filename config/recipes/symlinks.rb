set :stage_symlinks, %w(config/unicorn.conf config/settings.yml)

namespace :deploy do
  desc 'Create symlinks to stage-specific configuration files and shared resources'
  task :create_stage_symlinks, roles: :app, except: { no_release: true } do

    symlink_command = stage_symlinks.map do |target|
      "ln -nfs #{shared_path}/#{target} #{release_path}/#{target}"
    end

    run "cd #{shared_path} && #{symlink_command.join(' && ')}"

  end
  after 'deploy:finalize_update', 'deploy:create_stage_symlinks'
end
