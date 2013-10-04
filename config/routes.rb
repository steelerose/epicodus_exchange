EpicodusExchange::Application.routes.draw do
  resources 'posts'
  resources 'votes', only: [:create]
  resources 'answers', except: [:index, :show]

  root 'posts#index'
end

# resources 'users', only: [:new, :create, :delete]
# resources 'comments', only: [:new, :create, :delete]
# resources 'votes', only: [:create]
# resources 'links', except: [:edit, :update]
# resources 'sessions', only: [:new, :create, :delete]

# root 'links#index'

# match '/new_post',  to: 'links#new',        via: 'get'
# match '/signup',    to: 'users#new',        via: 'get'
# match '/login',     to: 'sessions#new',     via: 'get'
# match '/logout',    to: 'sessions#delete',  via: 'delete'
