Rails.application.routes.draw do
	root 'recipes#index'
	get 'search' => 'recipes#search'
	# post 'recipes' => 'recipes#recipes'
	get 'recipes' => 'recipes#recipes'
	get 'ingredients' => 'recipes#ingredients'
	get 'about' => 'recipes#about'
	get 'contact' => 'recipes#contact'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
