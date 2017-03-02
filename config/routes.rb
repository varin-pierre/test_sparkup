Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  get 'resumes/index'
  get 'resumes/parse_entry'

  resources :users
  resources :resumes, only: [:index, :new, :create, :destroy, :parse_entry]
end

