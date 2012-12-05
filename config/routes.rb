Aquila::Application.routes.draw do

	match 'sign_up' => 'home#sign_up'
  match '/auth/:provider/callback' => 'authentications#create'
  match "/signout" => "authentications#session_destroy", :as => :signout

  resources :authentications
	resources :projects, except: [:destroy] do
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
		end
	end

  match "/set_language" => 'home#set_language', via: :post, as: 'set_language'
  root :to => 'home#index'

end
