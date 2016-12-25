Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # constraints(Subdomain) do
  #   match '/' => 'instruments#visitka', via: :get
  # end

  concern :expand_node_and_rebuild do
    collection do
      post :rebuild
      post :expand_node
      get :expand_node
    end
  end

  get '/messages/feedback' => 'messages#feedback', as: 'users_feedback'

  authenticated :user, ->(u) { u.admin? } do
    namespace :old do
      resources :users, only: [:index, :update, :destroy], concerns: :expand_node_and_rebuild do
        post :complete, on: :member
      end

      resources :reviews do
        member do
          get :migrate
        end
      end

      get 'users(/:type)' => 'users#list', as: :users_type, constraints: {type: /#{Old::User::TYPES.join('|')}/}
    end

    resources :payments, only: [:index, :update] do
      get '/:type' => 'payments#list', as: :type, constraints: {type: /#{Payment::TAB_TYPES.join('|')}/}, on: :collection
      member do
        get :cancel
        post :manage
        get :complete
      end
    end

    resources :purse_payments, only: [:index, :show] do
      get '/:type' => 'purse_payments#list', as: :type, constraints: {type: /#{PursePayment::TAB_TYPES.join('|')}/}, on: :collection
    end

    resources :landing_contacts, only: [:index, :destroy] do
      get :read, on: :member
    end
  end

  authenticated :user do
    get 'stats' => 'home#stats', as: :stats
    get '/messages/new(/:message_type)' => 'messages#new', as: 'new_message', constraints: {message_type: /#{Message::TYPES.join('|')}/}

    get 'instruments/first_line' => 'instruments#first_line', as: :instruments_first_line
    get 'instruments/invited(/:type)' => 'instruments#invited', as: :instruments_invited

    resource :user, only: [] do
      get 'profile/:id' => 'users#profile', as: :profile
      collection do
        get :change_plan
        post :update_plan
        post :activate
      end
    end

    resources :documents, only: [:show, :create, :destroy]
    resources :users, only: [:index], concerns: :expand_node_and_rebuild do
      member do
        get :complete_form
        get :complete_close

        post :complete
        get :complete_voucher
      end
      collection do
        get 'login_as/:id' => 'users#login_as', as: :login_as
        resources :activation_requests, only: :index, as: :user_activation_requests
        resource :activation_request, only: :show, as: :user_activation_request
      end
    end

    get 'first_line' => 'users#first_line', as: :first_line
    get 'invited(/:type)' => 'users#invited', as: :invited, constraints: {type: /pending|accepted/}
    get 'my_structure' => 'users#structure', as: :structure

    resources :authentications, only: [:destroy]

    resources :activation_requests, only: [:index, :create, :update, :destroy] do
      get '/:type' => 'activation_requests#list', as: :list, constraints: {type: /#{ActivationRequest::TAB_TYPES.join('|')}/}, on: :collection
      member do
        post :change_plan
        post :manage
        get :invoice
        get :complete
      end
    end

    resources :payments, only: [] do
      get :invoice, on: :member
    end

    resources :voucher_requests, only: [:index, :create] do
      get '/:type' => 'voucher_requests#list', as: :list, constraints: {type: /#{VoucherRequest::TAB_TYPES.join('|')}/}, on: :collection
      member do
        get :activate
        get :cancel
        get :reject
      end
    end

    namespace :payment do
      resources :cash_deposits, only: [:index, :show, :new, :create, :update] do
        get :cancel, on: :member
      end
      resources :cash_withdrawals, only: [:index, :show, :new, :create] do
        get :cancel, on: :member
      end
    end

    namespace :purse_payment, path: :payment do
      resources :activations, only: :index do
        get '/:type' => 'activations#list', as: :list, constraints: {type: /all|first|second/}, on: :collection
      end

      resources :vouchers, only: [:index, :create]
      resources :points, only: [:index]
    end

    resources :vouchers, only: [:index, :create, :destroy] do
      get '/:type' => 'vouchers#list', as: :list, constraints: {type: /#{Voucher::TAB_TYPES.join('|')}/}, on: :collection
    end

    resources :informes

    resources :messages do
      member do
        get :toggle_active
      end
    end

    resources :companies, except: [:show] do
      resources :company_votes, only: [:create]
    end
    constraints(Subdomain) do
      get '/' => 'landings#index', as: :manager_subdomain_root
    end
    root to: 'home#dashboard', as: :manager_root
  end

  get 'privacy' => 'home#privacy', as: :privacy
  get 'terms' => 'home#terms', as: :terms
  get 'feedback' => 'home#feedback', as: :feedback
  get 'marketing' => 'home#marketing', as: :marketing

  post 'contacts' => 'home#notify'
  get 'vizitka/:token' => 'landings#index', as: :vizitka

  constraints(Subdomain) do
    get '/' => 'landings#index', as: :subdomain_root
    resources :landing_contacts, only: [:create]
  end

  root 'home#index'
end
