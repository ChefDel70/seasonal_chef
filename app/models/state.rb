class State < ApplicationRecord
	has_many :ingredient_states
	has_many :ingredients, through: :ingredient_states
end
