class RecipesController < ApplicationController

	def index
		@states = State.all
	end

	def ingredients
		@state = State.find(params[:state_id])
		@ingredients = @state.ingredients

	end

    def recipes
    	ingredients = params[:ingredients]
    	first_ingredient = ingredients[0]
    	other_ingredients = ingredients.last(ingredients.length - 1).join(", ")
    	if params[:ingredients].length == 1
    	    @recipes = RecipePuppy::Recipe.search_for(first_ingredient).get['results']
		else
			@recipes = RecipePuppy::Recipe.search_for(first_ingredient).with_ingredients(other_ingredients).get['results']
    	end
    end
end
