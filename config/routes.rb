TestBaby::Application.routes.draw do
  root :to => "student#index", :as => 'home'
  get "test/view1"

  get "student/register"
  get "student/login"
  get "student/index"
  get "student/infobox"
  get "student/nutshell"
  get "student/assignment"
  get "student/calendar"
  get "student/tabber"
  get "student/postview"
  get "student/upvote"
  get "twiliorespp/answerMachine"
  get "classrooms/show"
  get 'twilio' => 'twiliorespp#answerMachine'

  resources :classrooms
  resources :students
  resources :assignments
  resources :teachers
  resources :classrooms_students
  resources :grades
  
  

  match '/contact', :to => 'classrooms#show'
  match 'student/login', :to => 'student#login'
  match 'student/logout', :to => 'student#logout'
  match 'student/index', :to => 'student#index'
  match 'student/infobox', :to => 'student#infobox'
  match 'student/nutshell', :to => 'student#nutshell'
  match 'student/assignment', :to => 'student#assignment'
  match 'student/calendar', :to => 'student#calendar'
  match 'student/tabber', :to => 'student#tabber'
  match 'student/postview', :to => 'student#postview'
  match 'student/upvoteview', :to => 'student#upvote'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
