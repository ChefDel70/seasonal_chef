# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'

file = File.read(File.join(Rails.root, 'db/data.json'))
data = JSON.parse(file)

ingredients = [
  "apples",
  "apricots",
  "asian pears",
  "asparagus",
  "avocados",
  "beans",
  "beets",
  "bell pepper",
  "blackberries",
  "blueberries",
  "bok choy",
  "broccoli",
  "brussel sprouts",
  "cabbage",
  "cantaloupes",
  "carambola",
  "carrots",
  "cauliflower",
  "celery",
  "cherries",
  "corn",
  "cucumbers",
  "currants",
  "eggplant",
  "fennel",
  "grapefruits",
  "grapes",
  "greens",
  "guava",
  "halibut",
  "herbs",
  "honey",
  "kale",
  "lettuce",
  "lima beans",
  "longan",
  "lychee",
  "mango",
  "mushrooms",
  "nectarines",
  "okra",
  "onion",
  "oranges",
  "oysters",
  "papaya",
  "passion fruit",
  "peaches",
  "pears",
  "peanut",
  "peas",
  "pecans",
  "peppers",
  "pistachios",
  "plums",
  "pollock",
  "potatoes",
  "pumpkins",
  "radishes",
  "raspberries",
  "rhubarb",
  "rutabaga",
  "scallion",
  "shrimp",
  "snap bean",
  "spinach",
  "squash",
  "strawberries",
  "sweet corn",
  "sweet potatoes",
  "tangerines",
  "tomatoes",
  "turkey-bourbon red",
  "turkey-midget white",
  "turkey-standard bronze",
  "turnips",
  "watermelons",
  "zucchini",
]



def get_weeks_from_period(time_period)
	# time_period (string), that maps to a early or late period of a month
	# returns an array of integers that converts the time_period to series
	# of week numbers in a 52-week year.

	# data source:
	# http://www.simplesteps.org/eat-local/state/

	case time_period
	when ["Early", "January"]
		return [1, 2]
	when ["Late", "January"]
		return [3, 4]
	when ["Early", "February"]
		return [5, 6]
	when ["Late", "February"]
		return [7, 8]
	when ["Early", "March"]
		return [9, 10]
	when ["Late", "March"]
		return [11, 12, 13]
	when ["Early", "April"]
		return [14, 15]
	when ["Late", "April"]
		return [16, 17]
	when ["Early", "May"]
		return [18, 19]
	when ["Late", "May"]
		return [20, 21]
	when ["Early", "June"]
		return [22, 23]
	when ["Late", "June"]
		return [24, 25, 26]
	when ["Early", "July"]
		return [27, 28]
	when ["Late", "July"]
		return [29, 30]
	when ["Early", "August"]
		return [31, 32]
	when ["Late", "August"]
		return [33, 34]
	when ["Early", "September"]
		return [35, 36]
	when ["Late", "September"]
		return [37, 38, 39]
	when ["Early", "October"]
		return [40, 41]
	when ["Late", "October"]
		return [42, 43]
	when ["Early", "November"]
		return [44, 45]
	when ["Late", "November"]
		return [46, 47, 48]
	when ["Early", "December"]
		return [49, 50]
	when ["Late", "December"]
		return [51, 52]
	end
end

ingredients.each do |ingredient|
  Ingredient.create(name: ingredient)
end

def paths_in_data(data, parent)
    unless [Hash, Array].map{|class_| data.class == class_ }.any?
        return [parent]
    else
        items = []
        if data.class == Hash
          data.map do |k, v|
              items.push(paths_in_data(v, parent + [k, ]))
          end
        else
          data.map do |v|
              items.push(paths_in_data(v, parent + [data.index(v), ]))
          end
        end
    end
    return items.reduce(:+)
end

def get(path, obj)
  path.reduce(obj) { |obj, key| (obj && obj[key]) ? obj[key] : null }
end

# lookup =  Hash[[
#     'January',
#     'February',
#     'March',
#     'April',
#     'May',
#     'June',
#     'July',
#     'August',
#     'September',
#     'October',
#     'November',
#     'December',
# ].product(['Early', 'Late']).map.with_index do |key, index|
#   month, period = key
#   [[period, month], index + 1]
# end]

data.slice(0, 2).each do |state|
  paths_in_data(state, []).each do |path|
    state_name, period_month, get_weeks_from_period = path
    state = State.find_or_create_by(name: state_name)
    ingredient_chk = Ingredient.find_or_create_by(name: ingredient.downcase)

    week_add = In_season_week.find_or_create_by(in_season_week: get_weeks_from_period)
    p [state_name, get(path, state), lookup[period_month]]
  end
end

# create_table "ingredient_states", force: :cascade do |t|
#   t.integer "state_id"
#   t.integer "ingredient_id"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.integer "in_season_week"
# end
#
# create_table "ingredients", force: :cascade do |t|
#   t.string "name"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end

# data.each do |state|
#   state.each do |state_name, value|
#       state = State.create(name: state_name)
#       value.each do |collection|
#         collection.each do |k, v|
#           puts "xxx: #{k}"
#           puts lookup.fetch(k, 'nothing')
#         end
#       end
#     end
# end
