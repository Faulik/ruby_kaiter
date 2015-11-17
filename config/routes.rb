Rails.application.routes.draw do
  devise_for :people, skip: :sessions, failure_app: API::FailureApp
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount API::Engine => '/api'

  get 'welcome/index'

  root 'welcome#index'
end
