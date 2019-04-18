Rails.application.routes.draw do

  root 'static_pages#home'
  get 'login', to:'sessions#new'
  post 'login', to:'sessions#create'
  delete 'logout', to:'sessions#destroy'
  get 'edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  patch 'update-basic-info', to: 'users#update_basic_info'
  get 'users/:user_id/works/:date/edit', to: 'works#edit', as: :edit_works
  post 'users/:user_id/works/:date/update', to: 'works#update', as: :update_works
  resources :users do
   resources :works, only: [:create]
  end
  resources :branches
end
