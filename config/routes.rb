# frozen_string_literal: true

Rails.application.routes.draw do
  defaults format: :json do
    devise_for :users, only: :sessions

    namespace :api do
      namespace :v1 do
        resources :sleep_records, except: %i[new edit]
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
