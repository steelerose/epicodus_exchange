EpicodusExchange::Application.routes.draw do
  devise_for :users

  resources 'posts'
  resources 'votes', only: :create
  resources 'answers', except: [:index, :show]
  resources 'comments', only: [:new, :create, :destroy]
  resources 'users', only: [:index, :show, :destroy]

  root 'posts#index'

  match '/about', to: 'static_pages#about', via: 'get'
  match '/help', to: 'static_pages#help', via: 'get'
end
