Aquila::Application.routes.draw do
  resources :tags
  resources :brigade_projects
  resources :brigades
  resources :members

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
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

  match 'signup', to: 'pages#sign_up', via: [:get, :post]
  resource :dashboard, only: :show, controller: :dashboard do
    resources :collaborators, only: :index, controller: 'dashboard/collaborators'
    resources :challenges, only: [:index, :new, :edit, :create, :update], controller: 'dashboard/challenges' do
      resources :emails, only: [:new, :create], controller: 'dashboard/mailers' do
        get :finalists, to: 'dashboard/mailers', as: 'finalists', on: :new
        get :participants, to: 'dashboard/mailers', as: 'participants', on: :new
      end

      post :request_permission_for_challenge, controller: 'dashboard/evaluations'
      get :new_criteria, controller: 'dashboard/challenges'
      post :create_criteria, controller: 'dashboard/challenges'
      get :close_evaluation, controller: 'dashboard/challenges'

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
    resources :judges, only: [:index, :new, :create, :show], controller: 'dashboard/judges' do
      resources :evaluations, only: :destroy, controller: 'dashboard/evaluations'
      resources :report_cards, only: [:show], controller: 'dashboard/report_cards'
    end
    resources :report_cards, only: :index, controller: 'dashboard/report_cards'
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
    resources :challenges, except: [:index, :new, :edit] do
      member do
        get :timeline
      end
      member do
        get :send_newsletter
        post :mail_newsletter
      end
    end
  end

  resources :members, only: [:show, :update, :edit]

  namespace :panel do
    resources :entries, only: [:index, :show, :edit, :update] do
      resources :comments, only: :index
    end
  end

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

  match '/set_language', to: 'pages#set_language', via: :post, as: 'set_language'
  # match "/terms_of_service" => 'pages#terms_of_service', via: :get, as: 'terms_of_service'
  match '/privacy', to: 'pages#privacy', via: :get, as: 'privacy'
  # get "/about", to: "pages#about", as: "about"
  get '/start_a_challenge', to: 'pages#start_a_challenge', as: 'start_a_challenge'
  get '/location_search/:location_query', to: 'location#location_search'
  get '/brigade_search/:brigade_query', to: 'brigades#brigade_search'
  get '/brigade_search/', to: 'brigades#brigade_search'
  get '/location_name/:location_id', to: 'location#location_name'
  get '/location_unique/:location_id', to: 'location#location_unique'
  get '/follow/:userid/:brigadeid', to: 'brigades#follow'

  root to: 'challenges#index'

  # Catch for Challenges when call as project/:id/ due to model rename
  match '/projects/:id', to: 'challenges#show', via: [:get, :post]
  match '/projects/:id/timeline', to: 'challenges#timeline', via: [:get, :post]

  get ':organization_slug', to: 'organizations#show', as: 'organization_profile'
end
