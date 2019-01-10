Rails.application.routes.draw do
  devise_for :users
  root 'timelines#index'
  resources :timelines, only: [:index, :show, :edit, :update] do
    member do
      post :create_post
    end
  end
end
