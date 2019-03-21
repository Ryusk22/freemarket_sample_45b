server '54.64.150.97', user: 'ec2-user', roles: %w{app db web}
server '52.196.209.2', user: 'ec2-user', roles: %w{app db web}

set :rails_env, "production"
set :unicorn_rack_env, "production"
