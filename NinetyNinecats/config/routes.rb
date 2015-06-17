NinetyNinecats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests
  resource :user
  resource :session
end
