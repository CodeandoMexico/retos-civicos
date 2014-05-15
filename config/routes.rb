Aquila::Application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  namespace :admins do
    resources :organizations, only: [:index] do
      member { put :accept }
    end
  end

  match 'signup' => 'home#sign_up'

  resource :dashboard, only: :show, controller: :dashboard do
    resources :collaborators, only: :index, controller: 'dashboard/collaborators'
    resources :challenges, only: :index, controller: 'dashboard/challenges'
    resources :entries, only: [:show, :index], controller: 'dashboard/entries' do
      post :publish, on: :member
    end
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
    resources :comments do
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

  match "/set_language" => 'home#set_language', via: :post, as: 'set_language'

  root :to => 'challenges#index'

  # Catch for Challenges when call as project/:id/ due to model rename
  match "/projects/:id" => 'challenges#show'
  match "/projects/:id/timeline" => 'challenges#timeline'

  get ':organization_slug', to: 'organizations#show', as: 'organization_profile'
end
ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
