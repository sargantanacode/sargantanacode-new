Rails.application.routes.draw do
  scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users
    resources :posts, only: [:show]
    resources :admins, only: [:new, :create]
    resources :categories, only: [:index, :show]
    root to: "posts#index", as: "homepage"

    # Simplifying public-zone's menu links
    get "/about-us/" => "posts#show", defaults: {id: "about-us"}, as: "about_us"

    # Redirecting old links for the new ones
    get "/category/:category" => redirect("/categories/%{category}")

    namespace :admin do
      resources :posts, except: [:show] do
        put :publish, as: "publish"
        put :draft, as: "draft"
        put :destroy_image, as: "destroy_image"
      end
      resources :users, except: [:new, :create]
      resources :categories, except: [:show]
    end
  end
  get "/*path" => "application#change_path", constraints: { path: /(?!(#{I18n.available_locales.join("|")})\/).*/ }
  root to: "application#change_path"
end
