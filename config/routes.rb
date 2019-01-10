Rails.application.routes.draw do
  devise_for :users
  root 'timelines#index'
end
