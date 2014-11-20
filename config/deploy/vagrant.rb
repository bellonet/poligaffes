set :git_shallow_clone, 1
set :rails_env, :production

role :web, '10.0.0.2'
role :app, '10.0.0.2'
role :db,  '10.0.0.2'

server '10.0.0.2', roles: [:web, :app, :db], user: 'poligaffes'