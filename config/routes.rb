Rails.application.routes.draw do

  get 'likes/create'

  get 'likes/destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get '/' => 'home#index', as: :home
  root 'home#index'
  get '/about' => 'home#about'
  get '/contact' => 'home#contact'
  get '/faq' => 'home#faq'
  post '/contact_submit' => 'home#contact_submit'

  # resources :questions do
  #   post 'comments' =>'comments#create'
  # end
  resources :favorites, only: :index
  resources :products do
    resource :favorites, only: [:create, :destroy]
    # resources :comments, only: [:create]
    resources :reviews, only: [:create, :destroy]
  end
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
  resources :users, only: [:new, :create]
  namespace :admin do
    # get 'questions' => 'questions#index'
    #WTF is this doing?
    resources :questions
    # get '/products/new' => 'products#new', as: :new_product
    # post '/products/new' => 'products#create', as: :create_product
  end


end
