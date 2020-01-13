Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {
                     sessions: 'users/sessions',
                     registrations: 'users/registrations',
                     passwords: 'users/passwords',
                     confirmations: 'users/confirmations',
                     omniauth_callbacks: 'users/omniauth_callbacks'
                   }, path: '/', path_names: { sign_in: 'sign_in', sign_out: 'sign_out',registration: 'register' }
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/sign_in', to: 'users/sessions#new'
    get '/sign_out', to: 'users/sessions#destroy'
    get '/sign_up', to: 'users#new'
    get '/register', to: 'users/registrations#new'
  end
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :articles, only: [:index, :show]
  resources :categories, only: [:show]
  resources :comments

  namespace "admin" do
    namespace "dashboard" do
      resources :articles
      resources :categories
      resources :users
      resources :cities
    end
  end

  get '/admin/dashboard' => 'admin/dashboard/base#index'
  get '/admin' => 'admin/dashboard/base#index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
