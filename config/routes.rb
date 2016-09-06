Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :vbulletin, defaults: { format: :json } do
    get 'topic' => 'topic#index'
  end

  namespace :facebook, defaults: { format: :json } do
    get 'feed' => 'feed#index'
  end
end

