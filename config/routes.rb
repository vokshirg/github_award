Rails.application.routes.draw do
  root 'awards#index'
  resource :awards, only: [:index]
  get 'awards/repo_awards', to: 'awards#repo_awards'
end
