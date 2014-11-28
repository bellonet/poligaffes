set :git_shallow_clone, 1
set :rails_env, :production

role :web, 'hertzel.ronen.me'
role :app, 'hertzel.ronen.me'
role :db,  'hertzel.ronen.me'

server 'hertzel.ronen.me', roles: [:web, :app, :db], user: 'poligaffes'