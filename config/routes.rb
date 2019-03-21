Rails.application.routes.draw do

devise_for :users, :controllers => {
 :omniauth_callbacks => 'users/omniauth_callbacks',
 :registrations => 'users/registrations',
 :sessions => 'users/sessions'
}

  root 'products#index'
  resources :products do
    resources :comments, only: [:create, :destroy]
      collection do
        get 'category'
        get 'postage'
        get 'search'
      end
      member do
        get 'buy'
      end
  end
  post   '/like/:product_id' => 'likes#create',   as: 'like'
  delete '/like/:product_id' => 'likes#destroy', as: 'unlike'

  resources :users do
    collection do
      get 'logout'
    end
  end
  resources :profiles
  resources :payments
  resources :trades, only: :update
  get   'select', to: 'users#registration_select', as: 'registration_select'

end
