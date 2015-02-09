set :git_shallow_clone, 1
set :rails_env, :production

role :web, 'golda'
role :app, 'golda'
role :db,  'golda'

server 'golda', roles: [:web, :app, :db], user: 'poligaffes'