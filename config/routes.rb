Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: 'application#home'

  # auth
  post "/auth/create_account", to: 'auth#register'
  post "/auth/login", to: 'auth#login'

  # account
  post "/account/view", to: 'account#index'
  post "/account/topup", to: 'account#topup'
  post "/account/withdraw", to: 'account#withdraw'
  post "/account/transfer", to: 'account#transfer'
  get "/account/transactions/:type", to: 'account#transactions'

  # transaction

  match '*unmatched', to: 'application#missing_route', via: [:patch, :put, :get, :post, :delete]

end
