# frozen_string_literal: true

Rails.application.routes.draw do
  defaults format: :json do
    devise_for :users, only: :sessions

    namespace :api do
      namespace :v1 do
        resources :sleep_records, except: %i[new edit]
        resources :followings, only: %i[index create destroy] do
          scope module: :followings, as: :followings do
            collection do
              resources :sleep_records, only: :index
            end
          end
        end
      end
    end
  end

  apipie

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
