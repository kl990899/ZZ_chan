Rails.application.routes.draw do
  root to: "discussion_threads#index"

  resources :discussion_threads do
    resources :posts, only: [:create, :new]
  end

  # SEO routes
  get 'sitemap.xml', to: 'sitemap#index', as: :sitemap, defaults: { format: :xml }
  get 'robots.txt', to: 'robots#index', as: :robots, defaults: { format: :text }
end
