Rails.application.routes.draw do
  resources :tests
  resources :logs
  resources :captchas
  resources :pages
  resources :seas
  resources :adverts
  resources :sea_attacks
  mount DelayedJobWeb => "/delayed_job" if ["test", "production"].include?(Rails.env)
  resources :activity_servers
  resources :objectives
  resources :tasks
  match '/adverts/:id/publish', to: 'adverts#publish', via: [:patch], as: :publish_advert
  match '/adverts/:id/unpublish', to: 'adverts#unpublish', via: [:patch], as: :unpublish_advert
  match '/adverts/:id/manual', to: 'adverts#manual', via: [:patch], as: :manual_advert
  match '/adverts/:id/auto', to: 'adverts#auto', via: [:patch], as: :auto_advert
  match '/traffics/:id/publish', to: 'traffics#publish', via: [:patch], as: :publish_traffic
  match '/traffics/:id/unpublish', to: 'traffics#unpublish', via: [:patch], as: :unpublish_traffic
  match '/traffics/:id/manual', to: 'traffics#manual', via: [:patch], as: :manual_traffic
  match '/traffics/:id/auto', to: 'traffics#auto', via: [:patch], as: :auto_traffic
  match '/sea_attacks/:id/publish', to: 'sea_attacks#publish', via: [:patch], as: :publish_sea_attack
  match '/sea_attacks/:id/unpublish', to: 'sea_attacks#unpublish', via: [:patch], as: :unpublish_sea_attack
  match '/sea_attacks/:id/manual', to: 'sea_attacks#manual', via: [:patch], as: :manual_sea_attack
  match '/sea_attacks/:id/auto', to: 'sea_attacks#auto', via: [:patch], as: :auto_sea_attack
  match '/tasks/:id/start', to: 'tasks#start', via: [:patch], as: :start_task
  match '/calendar/prev_day', to: 'calendar#prev_day', via: [:get], as: :prev_day_calendar
  match '/calendar/today', to: 'calendar#today', via: [:get], as: :today_calendar
  match '/calendar/next_day', to: 'calendar#next_day', via: [:get], as: :next_day_calendar
  match '/calendar', to: 'calendar#index', via: [:get], as: :index_calendar
  match '/calendar/execute', to: 'calendar#execute', via: [:get], as: :execute_calendar
  match '/calendar/day', to: 'calendar#day', via: [:get], as: :day_calendar
  match '/visits/publish', to: 'visits#publish', via: [:get], as: :publish_visit
  match '/visits/publish_all', to: 'visits#publish_all', via: [:get], as: :publish_all
  match '/visits/delete', to: 'visits#delete', via: [:get], as: :delete_visit
  match '/visits/delete_all_by_state', to: 'visits#delete_all_by_state', via: [:get], as: :delete_all_by_state
  match '/visits/refresh', to: 'visits#refresh', via: [:get], as: :refresh_visit
  match '/visits/:visit_id/browsed_page', to: 'visits#browsed_page', via: [:patch], as: :browsed_page_visit
  match '/visits/:visit_id/started', to: 'visits#started', via: [:patch], as: :started_visit
  match '/visits/order_by', to: 'visits#order_by', via: [:get], as: :order_by_visit
  match '/seas/:id/publish', to: 'seas#publish', via: [:patch], as: :publish_sea
  resources :visits do
    resource :pages
    resource :captchas
    resource :log
  end
  resources :adverts do
    collection do
      delete :destroy_all
    end
  end

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
  resources :sea_attacks do
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
  resources :seas do
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
