class CreateIngredientStates < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_states do |t|
      t.integer :state_id
      t.integer :ingredient_id
      t.datetime :in_season_begin_date
      t.datetime :in_season_end_date

      t.timestamps
    end
  end
end
