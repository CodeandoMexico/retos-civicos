Aquila::Application.routes.draw do

  ninsho_on :authentications

	#match 'sign_up' => 'home#sign_up'
  #match '/auth/:provider/callback' => 'authentications#create'
  #match "/signout" => "authentications#session_destroy", :as => :signout
  match '/about' => 'home#about'

  namespace :open_data_zapopan, path: 'opendatazapopan' do
    resources :challenges, only: [:index, :show]
  end

  resources :organizations, only: [:show, :update, :edit] do
    resources :challenges, except: [:index] do
      member do
        get :timeline
      end
    end
  end

  resources :members, only: [:update, :edit]

  resources :authentications

	resources :challenges, only: [:index, :show] do
    resources :collaborations, only: [:create]
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
  root :to => 'home#index'

  # Catch for Challenges when call as project/:id/ due to model rename
  match "/projects/:id" => 'challenges#show'
  match "/projects/:id/timeline" => 'challenges#timeline'

end
ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
