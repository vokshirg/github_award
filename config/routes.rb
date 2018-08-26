Rails.application.routes.draw do
  root 'awards#index'
  resource :awards, only: [:index]
  get 'awards/repo_awards', to: 'awards#repo_awards'
  get 'awards/diplom', to: 'awards#diplom'
  get 'awards/download_zip', to: 'awards#download_zip'
end
