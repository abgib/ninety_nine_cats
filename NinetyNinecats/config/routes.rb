NinetyNinecats::Application.routes.draw do
  resources :cats, only: [:index, :show, :new, :create]
end
