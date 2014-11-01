Rails.application.routes.draw do

  get '/signup', to: 'users#new', as: "signup"    
  get '/login', to: 'sessions#new', as: "login"
  get '/logout', to: 'sessions#destroy', as: "logout"

  get 'contact/index'

  get 'about/index'

  get 'home/index'

  get '/search', to: "home#search", as: 'search'

  get '/byletter/:letter', to: 'yairs#by_letter'

  root 'home#index'

  resources :yairs do
    resources :comments
  end

  resources :users
  resources :sessions

  match '/contacts', to: 'contacts#new', via: 'get'
	resources "contacts", only: [:new, :create]

end
