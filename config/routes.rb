Rails.application.routes.draw do

  get '/login', to: 'sessions#new', as: "login"
  get '/logout', to: 'sessions#destroy', as: "logout"

  get 'contact/index'

  get 'about/index'

  get 'home/index'

  get '/search', to: "home#search", as: 'search'

  get '/byletter/:letter', to: 'yairs#by_letter'

  root 'home#index'

  resources :yairs do
    resources :posts
  end

  resources :users
  resources :sessions

  match '/contacts', to: 'contacts#new', via: 'get'
	resources "contacts", only: [:new, :create]

end
