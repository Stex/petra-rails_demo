Rails.application.routes.draw do
  resources :users do
    collection do
      post :commit
      post :reset
    end
  end
end
