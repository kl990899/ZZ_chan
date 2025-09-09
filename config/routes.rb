Rails.application.routes.draw do
  root to: "discussion_threads#index"

  resources :discussion_threads do
    resources :posts, only: [:create, :new]
  end
end
