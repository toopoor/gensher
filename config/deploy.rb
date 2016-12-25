# config valid only for Capistrano 3.1
lock '3.6.1'

set :repo_url, 'git@github.com:mashine-hq/gensherman.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

set :db_local_clean, false
set :db_remote_clean, true
set :assets_dir, 'public/uploads'
set :local_assets_dir, 'public'

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/database_old.yml
                      config/secrets.yml config/application.yml)

# Default value for linked_dirs is []
set :linked_dirs, %w(log private tmp/pids tmp/cache tmp/sockets vendor/bundle
                     public/system public/uploads)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3
set :keep_assets, 3

set :delayed_job_workers, 2

set :rvm_map_bins, fetch(:rvm_map_bins, []).push('bin/delayed_job')

namespace :deploy do
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  #
  # after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before :restart, 'unicorn:start'
  after :restart, 'unicorn:start'
end

# namespace :assets do
#   desc 'copy ckeditor nondigest assets'
#   task :precompile do
#     on roles(fetch(:assets_roles)) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, "ckeditor:create_nondigest_assets"
#         end
#       end
#     end
#   end
# end

# after 'deploy:assets:precompile', 'copy_nondigest_assets'
before 'unicorn:stop', 'delayed_job:stop'
after 'unicorn:start', 'delayed_job:start'
