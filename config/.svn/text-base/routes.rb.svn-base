ActionController::Routing::Routes.draw do |map|
  map.resources :testusers

  map.resource :testsession

  map.resources :testusers

  map.resource :testsession

  map.resource  :session
  map.signup '/signup', :controller => 'users', :action => 'register'
  map.signup '/addRestaurant', :controller => 'notification', :action => 'restaurantOwners'
  map.login  '/login', :controller => 'session', :action => 'login'
  map.logout '/logout', :controller => 'session', :action => 'logout'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  map.changePassword '/changePassword/:forgot_password_code', :controller => 'users', :action => 'changePassword', :forgot_password_code => nil 
  map.ownerAccount '/ownerAccount/:forgot_password_code', :controller => 'users', :action => 'ownerAccount', :forgot_password_code => nil 
    
    
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect '', :controller => 'main'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
