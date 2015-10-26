Rails.application.routes.draw do
  devise_for :people
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount API::Engine => '/api'

  get 'welcome/index'

  root 'welcome#index'
end
