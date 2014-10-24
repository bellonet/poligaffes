Rails.application.routes.draw do
  get 'contact/index'

  get 'about/index'

  get 'home/index'

  get '/search', to: "home#search", as: 'search'

  root 'home#index'

  resources :yairs do
    resources :comments
  end

  match '/contacts', to: 'contacts#new', via: 'get'
	resources "contacts", only: [:new, :create]

end
