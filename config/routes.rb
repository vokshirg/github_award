Rails.application.routes.draw do
  root 'awards#index'
  resource :awards, only: [:index]
end
