Rails.application.routes.draw do

  root 'static_pages#home'
  get 'login', to:'sessions#new'
  post 'login', to:'sessions#create'
  delete 'logout', to:'sessions#destroy'
  get 'edit-basic-info', to: 'users#edit_basic_info', as: :basic_info
  patch 'update-basic-info', to: 'users#update_basic_info'
  get 'users/:user_id/works/:date/edit', to: 'works#edit', as: :edit_works
  post 'users/:user_id/works/:date/update', to: 'works#update', as: :update_works
  post '/works/:id/sup_update', to: 'works#sup_update', as: :sup_update
  get 'index_time_in_users', to: 'users#index_time_in', as: :index_time_in
  get 'work_log_index', to: 'works#work_log_index', as: :work_log_index
  get 'index_works', to: 'works#index_works', as: :index_works
  resources :users do
   resources :works, only: [:create]
   collection { post :import }
  end
  resources :branches
  resources :month_approvals do
      post 'sup_update', on: :member
  end
  resources :over_approvals do
      post 'sup_update', on: :member
  end
end
