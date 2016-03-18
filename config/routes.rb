Rails.application.routes.draw do
  mount DelayedJobWeb => "/delayed_job" if ["test", "production"].include?(Rails.env)
  resources :activity_servers
  resources :visits
  resources :objectives
  resources :tasks
  match '/traffics/:id/publish', to: 'traffics#publish', via: [:patch], as: :publish_traffic
  match '/traffics/:id/unpublish', to: 'traffics#unpublish', via: [:patch], as: :unpublish_traffic
  match '/tasks/:id/start', to: 'tasks#start', via: [:patch], as: :start_task

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
