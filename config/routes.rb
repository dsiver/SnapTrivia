Snaptrivia::Application.routes.draw do

  resources :questions, :subjects, :messages

  get 'add_question/challenge'
  get 'game_home/gameHome'
  get 'questions/new'
  get 'questions/challenge' => 'questions#challenge'
  get 'game/ask_question'
  get 'game/challenge'
  get 'game/index'
  get 'game/cancel_transaction'
  get 'game/success_transaction'
  get 'statistics/user_stats'
  get 'statistics/site_stats'
  get 'game/game' => 'game#game'
  get 'game/question_results' => 'game#question_results'
  get 'game/end_game'
  get 'game/challenge'



  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'


  get "game/rules"
  get "game/welcome"

  devise_for :reviewers
  devise_for :admins
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", registrations: 'registrations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'game#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
