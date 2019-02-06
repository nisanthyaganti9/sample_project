Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :edit, :create, :update, :show] do
    collection do
      get :existing_user
      post :sign_in
    end

    member do
      get :change_password
      post :submit_password
    end
  end

  root "users#new"
end
