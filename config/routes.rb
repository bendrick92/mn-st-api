Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :vbulletin, defaults: { format: :json } do
    get 'forums' => 'forums#index'
    get 'topics' => 'topics#index'
    get 'posts' => 'posts#index'
  end
end

