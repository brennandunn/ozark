default_run_options[:pty] = true

set :application, "ozark"
set :deploy_to,   "/u/apps/#{application}"
set :domain,      "brennandunn.com"
set :repository,  "git@github.com:brennandunn/ozark.git"
set :use_sudo,    false
set :scm,         "git"
set :branch,      "origin/master"
set :ssh_options, { :forward_agent => true }


role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end