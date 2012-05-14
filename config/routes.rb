Offbot::Application.routes.draw do
  devise_for :people
  
  resources :projects
  resources :people
  resources :updates

  devise_for :people, :path => "you", :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'sign_up' }

  match "/sendmail/incoming" => "listener#receive_email", :via => :post
  match '/about' => 'pages#about'
  match '/my_updates' => 'updates#my_index'
  match '/projects/:id/updates/:tag' => 'updates#tagged'
  match '/you/generate_email_key/:id' => 'people#generate_email_key', :as => "generate_email_key"

  authenticate :person do
    root :to => 'projects#my_index'
  end


  # See how all your routes lay out with "rake routes"

end
