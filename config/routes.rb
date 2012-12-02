Aquila::Application.routes.draw do

  match '/auth/:provider/callback' => 'authentications#create'
  match "/signout" => "authentications#session_destroy", :as => :signout

  resources :authentications
	resources :projects, except: [:destroy] do
		member do
			put :cancel
			post :collaborate
		end
	end

  root :to => 'home#index'

end
