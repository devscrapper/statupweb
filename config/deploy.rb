#---------------------------------------------------------------------------------------------------------------------
# deploy Rail 4 avec capistrano V3
#---------------------------------------------------------------------------------------------------------------------
#
# first deploy :
# -------------
# install rvm :
# install ruby :
# install mysql :
# install passenger/nginx :

# Next deploy :
# -------------
# avant tout deploy, il faut publier sur https://devscrapper/statupweb.git avec la commande
# git push origin master
#
# pour deployer dans un terminal avec ruby 223 dans la path : cap production deploy
# cette commande prend en charge :
# la publication des sources vers le serveur cible
# les migration mysql
# la publication des fichiers de paramèrage : database.yml, secret.yml(n'est pas utilisé, car on lit la var d'enviroennemnt
# dans le fichier application.config.rb => la var est defini dans le fichier /etc/profile : EXPORT SECRET_KEY_BASE="la clé")
# les liens vers les repertoires partagés et le current vers les relaease
# le redemarrage de passenger
# le redemraage de delay_job (en production)
#---------------------------------------------------------------------------------------------------------------------

lock '3.4.1'

set :application, 'statupweb'
set :repo_url, "git@github.com://github.com/devscrapper/#{fetch(:application)}.git/"
set :repo_url, "https://github.com/devscrapper/#{fetch(:application)}.git/"
set :github_access_token, '64c0b7864a901bc6a9d7cd851ab5fb431196299e'
set :default, 'master'
set :user, 'eric'
set :pty, true
set :use_sudo, false
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :rvm_ruby_version, '2.2.3'
set :passenger_rvm_ruby_version, '2.2.3'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, ['config/GeoLite2-City.mmdb']).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'config/publication.yml',
                                                 'config/extern_uri.yml',
                                                 'config/calendar.yml',
                                                 'config/scheduler.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, {path: "/opt/ruby/bin:$PATH"}

# Default value for keep_releases is 5
set :keep_releases, 3

set :passenger_roles, :app
set :passenger_restart_runner, :sequence
set :passenger_restart_wait, 5
set :passenger_restart_limit, 2
set :passenger_restart_with_sudo, false
set :passenger_environment_variables, {}
set :passenger_restart_command, 'passenger-config restart-app'
set :passenger_restart_options, -> { "#{fetch(deploy_to)} --ignore-app-not-running" }


# Number of delayed_job workers
# default value: 1
set :delayed_job_workers, 2

# String to be prefixed to worker process names
# This feature allows a prefix name to be placed in front of the process.
# For example:  reports/delayed_job.0  instead of just delayed_job.0
set :delayed_job_prefix, :reports

# Delayed_job queue or queues
# Set the --queue or --queues option to work from a particular queue.
# default value: nil
set :delayed_job_queues, nil

# Specify different pools
# You can use this option multiple times to start different numbers of workers for different queues.
# default value: nil
set :delayed_job_pools, {
                          :* => 2
                      }

# Set the roles where the delayed_job process should be started
# default value: :app
set :delayed_job_roles, [:app, :background]

# Set the location of the delayed_job executable
# Can be relative to the release_path or absolute
# default value 'bin'
#set :delayed_job_bin_path, 'script' # for rails 3.x

### Set the location of the delayed_job logfile
set :delayed_log_dir, '/log'

### Set the location of the delayed_job pid file
set :delayed_job_pid_dir, '/tmp'

before 'deploy:check:linked_files', 'config:push'

# before 'deploy:starting', 'github:deployment:create'
# after  'deploy:starting', 'github:deployment:pending'
# after  'deploy:finished', 'github:deployment:success'
# after  'deploy:failed',   'github:deployment:failure'


#----------------------------------------------------------------------------------------------------------------------
# task list : log
#----------------------------------------------------------------------------------------------------------------------
namespace :install do
  task :geolite2city do
    on roles(:app) do
         within shared_path do
           execute :rm, "-rf", "#{shared_path}/config/GeoLite2-City.mmdb.gz" if test("[ -d #{shared_path}/config/GeoLite2-City.mmdb.gz ]")
           execute :wget, " --output-document=#{shared_path}/config/GeoLite2-City.mmdb.gz", "http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz"
           execute :gunzip, "-df", "#{shared_path}/config/GeoLite2-City.mmdb.gz"
         end
       end
  end
end

namespace :deploy do
  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, "--gemfile Gemfile --path #{shared_path}/bundle  --binstubs #{shared_path}bin --without [:development]"
      end
    end
  end
  after 'deploy:updating', 'deploy:bundle_install'

  after 'deploy:bundle_install', 'install:geolite2city'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
