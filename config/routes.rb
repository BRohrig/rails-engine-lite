Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/find#search'
      get 'items/find_all', to: 'items/find#find_all'

      resources :merchants, only: %i[index show] do
        resources :items, only: :index, controller: 'merchants/items'
      end

      resources :items do
        resources :merchant, only: :index, controller: 'items/merchant'
      end
    end
  end
end
