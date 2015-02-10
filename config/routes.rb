Aquila::Application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: 'users/passwords'
  }

  namespace :admins do
    resources :organizations, only: [:index] do
      member { put :accept }
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :challenges
    end
  end

  match 'signup' => 'pages#sign_up'

  resource :dashboard, only: :show, controller: :dashboard do
    resources :collaborators, only: :index, controller: 'dashboard/collaborators'
    resources :challenges, only: :index, controller: 'dashboard/challenges' do
      resources :emails, only: [:new, :create], controller: 'dashboard/mailers' do
        get :finalists, to: 'dashboard/mailers', as: 'finalists', on: :new
        get :participants, to: 'dashboard/mailers', as: 'participants', on: :new
      end

      post :request_permission_for_challenge, controller: 'dashboard/evaluations'
      get :new_criteria, controller: 'dashboard/challenges'
      post :create_criteria, controller: 'dashboard/challenges'

      resources :evaluations, only: [:show, :new, :create], controller: 'dashboard/evaluations'
    end
    resources :entries, only: [:show, :index], controller: 'dashboard/entries' do
      post :mark_valid, on: :member
      post :mark_invalid, on: :member
      post :publish, on: :member
      post :accept, on: :member
      post :winner, on: :member
      post :remove_winner, on: :member
    end
    resources :judges, only: [:index, :new, :create], controller: 'dashboard/judges'
  end

  resources :judges, only: [:edit, :update]
  resources :evaluations, only: [:index, :show] do
    resources :report_cards, except: [:new, :create, :destroy]
  end

  resources :organizations, only: [:update, :edit] do
    member do
      get :subscribers_list
    end
    resources :subscribers, only: [:create]
    resources :challenges, except: [:index] do
      member do
        get :timeline
      end
      member do
        get :send_newsletter
        post :mail_newsletter
      end
    end
  end

  resources :members, only: [:update, :edit]

  resources :authentications

  resources :challenges, only: [:index, :show] do
    resources :votes, only: [:create]
    resources :collaborations, only: [:create]
    resources :entries, except: [:destroy]
    resources :prototypes, only: [:new, :create, :edit, :update]
    resources :comments do
      get :guest, on: :collection
      member do
        post :like
        post :reply
      end
    end
    member do
      put :cancel
      post :like
      get :timeline
    end
  end

  resources :users do
    collection do
      get :define_role
    end
    member do
      put :set_role
    end
  end

  match "/set_language" => 'pages#set_language', via: :post, as: 'set_language'
  match "/terms_of_service" => 'pages#terms_of_service', via: :get, as: 'terms_of_service'
  match "/privacy" => 'pages#privacy', via: :get, as: 'privacy'
  get "/about", to: "pages#about", as: "about"

  root :to => 'challenges#index'

  # Catch for Challenges when call as project/:id/ due to model rename
  match "/projects/:id" => 'challenges#show'
  match "/projects/:id/timeline" => 'challenges#timeline'

  get ':organization_slug', to: 'organizations#show', as: 'organization_profile'
end
ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
