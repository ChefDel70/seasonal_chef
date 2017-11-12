Rails.application.routes.draw do
	root 'ingredient_states#index'
	get 'search' => 'ingredient_states#search'
	# post 'recipes' => 'ingredient_states#recipes'
	get 'recipes' => 'ingredient_states#recipes'
	get 'show' => 'ingredient_states#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  	get 'local_ingredients' => 'ingredient_states#local_ingredients'

end
