Offbot::Application.routes.draw do
  devise_for :people
  
  resources :projects
  resources :people
  resources :updates

  devise_for :people, :path => "you", :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'sign_up' }

  match "/sendmail/incoming" => "listener#receive_email", :via => :post

  authenticate :person do
    root :to => 'projects#my_index'
  end


  # See how all your routes lay out with "rake routes"

end
