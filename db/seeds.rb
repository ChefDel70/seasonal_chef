require "httparty"
require "nokogiri"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# states variable contains the states that are being scraped from the website
states = ["Alabama",
  "Alaska",
  "Arizona",
  "Arkansas",
  "California",
  "Colorado",
  "Connecticut",
  "Delaware",
  "Florida",
  "Georgia",
  "Hawaii",
  "Idaho",
  "Illinois",
  "Indiana",
  "Iowa",
  "Kansas",
  "Kentucky",
  "Louisiana",
  "Maine",
  "Maryland",
  "Massachusetts",
  "Michigan",
  "Minnesota",
  "Mississippi",
  "Missouri",
  "Montana",
  "Nebraska",
  "Nevada",
  "New Hampshire",
  "New Jersey",
  "New Mexico",
  "New York",
  "North Carolina",
  "North Dakota",
  "Ohio",
  "Oklahoma",
  "Oregon",
  "Pennsylvania",
  "Rhode Island",
  "South Carolina",
  "South Dakota",
  "Tennessee",
  "Texas",
  "Utah",
  "Vermont",
  "Virginia",
  "Washington",
  "West Virginia",
  "Wisconsin",
  "Wyoming"
]

# map seasons to weeks of the year so that we can populate state_ingredients table with in_season_week field
def get_weeks_from_period(time_period)
  # time_period (string), that maps to a early or late period of a month
  # returns an array of integers that converts the time_period to series
  # of week numbers in a 52-week year.

  # data source:
  # http://www.simplesteps.org/eat-local/state/

  case time_period
  when "Early January"
    return [1, 2]
  when "Late January"
    return [3, 4]
  when "Early February"
    return [5, 6]
  when "Late February"
    return [7, 8]
  when "Early March"
    return [9, 10]
  when "Late March"
    return [11, 12]
  when "Early April"
    return [13, 14]
  when "Late April"
    return [15, 16]
  when "Early May"
    return [17, 18]
  when "Late May"
    return [19, 20]
  when "Early June"
    return [21, 22]
  when "Late June"
    return [23, 24]
  when "Early July"
    return [25, 26]
  when "Late July"
    return [27, 28]
  when "Early August"
    return [29, 30]
  when "Late August"
    return [31, 32]
  when "Early September"
    return [33, 34]
  when "Late September"
    return [35, 36]
  when "Early October"
    return [37, 38]
  when "Late October"
    return [39, 40]
  when "Early November"
    return [41, 42]
  when "Late November"
    return [43, 44]
  when "Early December"
    return [45, 46]
  when "Late December"
    return [47, 48]
  end
end


# *********Seed States**********
states.each do |state|
  State.create(name: state)
end
# *********/Seed States**********

# *********Beginning of Sanitation**********

# Sanitize ingredients that we want to rephrase or remove.
# For any item to omit add to "omit"
# For any item to rename first add the name to be modified followed by the rename
ingredients_to_omit = [ "Christmas Trees", "Wreathes"]
ingredients_to_rename = [
  ["Oysters, Eastern", "Oyster"],
  ["Turkey - Standard Bronze", "Turkey"],
  ["Turkey - Midget White", "Turkey"],
  ["Turkey - Bourbon Red", "Turkey"],
  ["Pollock (Alaskan)", "Cod"]
]

# *********End of Sanitation**********


# API Scraping **********
base_url = "http://www.simplesteps.org/eat-local/state/"
data = []
counter = 1
for state in states
  # puts "*** #{counter}.  #{state} ***"
  state_hash = {}
  state_hash[:state_name] = state
  url = "http://www.simplesteps.org/eat-local/state/#{state.downcase.tr_s(" ", "-")}"
  response = HTTParty.get url
  dom = Nokogiri::HTML(response.body)
  seasons = dom.css('.state-produce').css('.season')
  season_data = []
  for season in seasons
    season_hash = {}
    season_hash[:season_name] = season.css('h3').text
    # puts "--- #{season_hash[:season_name]} ---"
    ingredients = []
    for ingredient in season.css('a')
      if !ingredients_to_omit.include? ingredient.text
        # if ingredient is not in our omission list
        ingredients << ingredient.text
      end
    end
    # rename ingredients we flagged to be renamed
    for ingredient in ingredients_to_rename
      # if ingredients includes an ingredient to rename
      if ingredients.include? ingredient[0]
        # delete that ingredient and replace it
        ingredients.delete(ingredient[0])
        ingredients << ingredient[1]
      end
    end
    # remove duplicates
    ingredients.uniq!
    season_hash[:ingredients] = ingredients
    season_data << season_hash
  end
  state_hash[:season_data] = season_data
  data << state_hash
  counter += 1
end

# *********Seed Ingredients**********
#Compile all ingredients from all states, and all seasons into a single master ingredients array.
master_ingredients = []
for state in data       # for every state
  for season_hash in state[:season_data]      # for every season
    # state[:season_data] returns an array of hashes
    # loop through every hash in state[:season_data]
    for ingredient in season_hash[:ingredients]   # <- returns an array of ingredients
      master_ingredients << ingredient
    end
  end
end

master_ingredients.each do |ingredient|
  Ingredient.create(name: ingredient)
end
# *********/Seed Ingredients**********

# *********Seed IngredientState**********
for state in data
  state_obj = State.find_by(name: state[:state_name])
  state_name = state[:state_name]
  for season in state[:season_data]
    for week in get_weeks_from_period(season[:season_name])
      for ingredient in season[:ingredients]
        ingredient_obj =
        IngredientState.create(
          state: state_obj,
          ingredient: Ingredient.find_by(name: ingredient),
          in_season_week: week
        )
      end
    end
  end
end
# *********/Seed IngredientState**********
