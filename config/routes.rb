Rails.application.routes.draw do

  get '/login', to: 'sessions#new', as: "login"
  get '/logout', to: 'sessions#destroy', as: "logout"

  get 'stats/index'

  get 'about/index'

  get 'home/index'

  get '/search', to: "home#search", as: 'search'

  get '(/:field)/byletter/:letter', to: 'yairs#by_letter'

  root 'home#index'

  resources :yairs do
    resources :social_media_accounts do
      resources :posts
    end
    resources :posts
  end

  resources :social_media_accounts
  resources :posts

  resources :sessions

  match '/contacts', to: 'contacts#new', via: 'get'
	resources "contacts", only: [:new, :create]

  namespace :admin do
    root 'dashboard#index'
    resources :users
    resources :facebook_applications
    resources :fb_api_tokens
    post '/fb_api_tokens/:id/extend', to: 'fb_api_tokens#extend', as: 'extend_fb_api_token'
    get '/create_token_using_fb_flow', to: 'fb_api_tokens#create_using_fb_flow', as: 'facebook_login_flow'
    get '/callback_from_facush', to: 'fb_api_tokens#callback_from_facebook', as: 'facush_callback'
    get '/callback_from_parsed_url_fragment', to: 'fb_api_tokens#callback_from_parsed_url_fragment', as: 'callback_from_parsed_url_fragment'
  end

end
