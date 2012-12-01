Aquila::Application.routes.draw do

  resources :authentications

  match '/auth/:provider/callback' => 'authentications#create'
  match "/signout" => "authentications#session_destroy", :as => :signout

  root :to => 'home#index'

end
