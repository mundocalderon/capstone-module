Rails.application.routes.draw do
  get 'auth/whoami'

  get 'auth/checkme'

  mount_devise_token_auth_for 'User', at: 'auth'
  scope :api, defaults: {format: :json} do
    resources :cities, except: [:new, :edit]
    resources :states, except: [:new, :edit]

  end

  get "/client-assets/:name.:format", :to => redirect("/client/client-assets/%{name}.%{format}")
#  get "/", :to => redirect("/client/index.html")

  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root "ui#index"
end
