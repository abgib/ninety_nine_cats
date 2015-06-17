NinetyNinecats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests, only: [:create, :new] do
    post "approve", on: :member
    post "deny", on: :member
  end
  resource :user
  resource :session
end
