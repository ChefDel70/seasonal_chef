class Ingredient < ApplicationRecord
	has_many :ingredient_states
	has_many :states, through: :ingredient_states
end
