Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authentication/create'
      post 'sessions/create'
    end
  end
end
