Rails.application.routes.draw do

  resources :images do
    member do
      get 'get_image'
    end
  end

  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
