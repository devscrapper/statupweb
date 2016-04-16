Rails.application.routes.draw do
  mount DelayedJobWeb => "/delayed_job" if ["test", "production"].include?(Rails.env)
  resources :activity_servers
  resources :objectives
  resources :tasks
  match '/traffics/:id/publish', to: 'traffics#publish', via: [:patch], as: :publish_traffic
  match '/traffics/:id/unpublish', to: 'traffics#unpublish', via: [:patch], as: :unpublish_traffic
  match '/tasks/:id/start', to: 'tasks#start', via: [:patch], as: :start_task
  match '/calendar/prev_day', to: 'calendar#prev_day', via: [:get], as: :prev_day_calendar
  match '/calendar/today', to: 'calendar#today', via: [:get], as: :today_calendar
  match '/calendar/next_day', to: 'calendar#next_day', via: [:get], as: :next_day_calendar
  match '/calendar', to: 'calendar#index', via: [:get], as: :index_calendar
  match '/calendar/execute', to: 'calendar#execute', via: [:get], as: :execute_calendar
  match '/calendar/day', to: 'calendar#day', via: [:get], as: :day_calendar
  match '/visits/publish', to: 'visits#publish', via: [:get], as: :publish_visit
  match '/visits/delete', to: 'visits#delete', via: [:get], as: :delete_visit
  match '/visits/refresh', to: 'visits#refresh', via: [:get], as: :refresh_visit
  match '/visits/:visit_id/browsed_page', to: 'visits#browsed_page', via: [:patch], as: :browsed_page_visit

  resources :visits
  #match '/traffics/destroy_all', to:'traffics#destroy_all', via: [:delete], as: :destroy_all_traffic
  resources :ranks do
    collection do
      delete :destroy_all
    end
  end
  resources :traffics do
    collection do
      delete :destroy_all
    end
  end
  resources :statistics do
    collection do
      delete :destroy_all
    end
  end
  resources :websites do
    collection do
      delete :destroy_all
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  # put 'traffics/:id/publish'   => 'traffic#publish', as: :publish


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
