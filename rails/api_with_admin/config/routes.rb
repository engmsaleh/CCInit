

  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1 do
      root to: "application#index"

      # Add more API endpoints here
    end
  end

  root to: redirect("/api/v1")
