EpicodusExchange::Application.routes.draw do
  devise_for :users

  resources 'posts'
  resources 'votes', only: :create
  resources 'answers', except: [:index, :show]
  resources 'comments', only: [:new, :create, :destroy]
  resources 'users', only: [:show, :index]

  root 'posts#index'

  match '/results', to: 'posts#search', via: 'post'
end
