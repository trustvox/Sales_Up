Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "user#user_home"
  get "/forgot_password", to: "user#forgot_password", as: "forgot_password"
  get "/graphic", to: "home#graphic", as: "graphic"
  get "/spreadsheet", to: "home#spreadsheet", as: "spreadsheet"
  post "/searchG", to: "home#searchG"
  post "/searchS", to: "home#searchS"
 
end
