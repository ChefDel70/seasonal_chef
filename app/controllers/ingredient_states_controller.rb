class IngredientStatesController < ApplicationController

	def index
		@states = State.all 
	end 

	def show
		@ingredients = Ingredient.all
	end 

	def search_results
	end 

	def ingredients_in_season_now
		all_matches = self.ingredients
		all_matches
	end 

    def recipes
    	ingredient = params[:ingredient]
    	@recipes = RecipePuppy::Recipe.search_for(ingredient).get['results']
    	render json: @recipes  
    end 

    def search
    end
end
