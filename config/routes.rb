Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :vbulletin, defaults: { format: :json } do
    get 'topics' => 'topics#index'
  end

  namespace :facebook, defaults: { format: :json } do
    get 'feeds' => 'feeds#index'
  end

  namespace :poly, defaults: { format: :json } do
    get 'posts' => 'posts#index'
  end
end

