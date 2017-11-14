class UpdateIngredientStates < ActiveRecord::Migration[5.1]
  def change
  	remove_column :ingredient_states, :in_season_begin_date, :datetime
  	remove_column :ingredient_states, :in_season_end_date, :datetime
  	add_column :ingredient_states, :in_season_week, :integer
  end
end
