Rails.application.routes.draw do
	root 'ingredient_states#index'
	get 'show' => 'ingredient_states#show'
	get 'search_results' => 'ingredient_states#search_results'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
