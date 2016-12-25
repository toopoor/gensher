role :app, %w{sherman@138.68.84.172}
role :web, %w{sherman@138.68.84.172}
role :db,  %w{sherman@138.68.84.172}

set :application, 'staging'
set :branch, 'develop'
set :deploy_to, "/home/sherman/sites/#{fetch(:application)}"

server '138.68.84.172',
       user: 'sherman',
       roles: %w{web app},
       ssh_options: {
         user: 'sherman', # overrides user setting above
         #keys: %w(/home/deploy/.ssh/id_rsa),
         forward_agent: true,
         auth_methods: %w(publickey password)
         # password: 'please use keys'
       }

set :rails_env, :staging
set :unicorn_app_env, :staging
set :unicorn_workers, 4
set :unicorn_worker_timeout, 30
set :unicorn_service, "unicorn_#{fetch(:application)}_#{fetch(:stage)}"
set :unicorn_config, shared_path.join('config/unicorn.rb')
set :unicorn_pid, shared_path.join('tmp/pids/unicorn.pid')

set :nginx_server_name, 'staging.gensherman.com'
set :nginx_config_name, 'gensherman_qa'
set :nginx_pid, '/var/run/nginx.pid'
set :nginx_location, '/etc/nginx'
set :nginx_fail_timeout, 0
