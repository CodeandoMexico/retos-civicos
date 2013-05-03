Aquila::Application.routes.draw do

	match 'sign_up' => 'home#sign_up'
  match '/auth/:provider/callback' => 'authentications#create'
  match "/signout" => "authentications#session_destroy", :as => :signout
  match '/about' => 'home#about'

  namespace :open_data_zapopan, path: 'opendatazapopan' do
    resources :challenges, only: [:index]
  end

  resources :authentications
	resources :challenges, except: [:destroy] do
		resources :comments do
			member do
				post :like
				post :reply
			end
		end
    member do
      put :cancel
      post :collaborate
      post :like
      get :timeline
    end
	end

  match "/set_language" => 'home#set_language', via: :post, as: 'set_language'
  root :to => 'home#index'

  # Catch for Challenges when call as project/:id/ due to model rename
  match "/projects/:id" => 'challenges#show'
  match "/projects/:id/timeline" => 'challenges#timeline'

end

ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
