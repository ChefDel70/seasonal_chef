require "httparty"
require "nokogiri"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

states = [
  "Alabama",
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

states.each do |state|
  State.create(name: state)
end

ingredients = [
  "asian pears",
  "asparagus",
  "beans",
  "blackberries",
  "blueberries",
  "broccoli",
  "cabbage",
  "cantaloupes",
  "cherries",
  "cucumbers",
  "eggplant",
  "greens",
  "herbs",
  "nectarines",
  "peaches",
  "peas",
  "peppers",
  "plums",
  "potatoes",
  "raspberries",
  "rhubarb",
  "pumpkins",
  "squash",
  "strawberries",
  "sweet corn",
  "sweet potatoes",
  "tomatoes",
  "watermelons"
]

# set up seasons for ingredients
ingredients.each do |ingredient|
  Ingredient.create(name: ingredient)
end

url = "http://www.simplesteps.org/eat-local/state/florida"
response = HTTParty.get url

weeks_for_tp = {
  "EARLY JANUARY" => [1, 2],
  "LATE JANUARY" => [3, 4],
  "EARLY FEBRUARY" => [5, 6],
  "LATE FEBRUARY" => [7, 8],
  "EARLY MARCH" => [9, 10],
  "LATE MARCH" => [11, 12]
}

dom = Nokogiri::HTML(response.body)
@info = dom.css('.state-produce').map do |a|
  p "#{a.text}"
end

# directions for scraping and seeeding
# ------------------------------------
# grab each "season" using '.season' selector
# grab time period (ex: EARLY JANUARY) using h3 selector on the .season div
# then look at its ingredients
# compare its ingredients in here: https://imgur.com/s34yDxF to ingredients array
# if each ingredient is in the array, then find that ingredient via .find
# now create a ingredient_state for the said ingredient (& state) for each of the weeks_for_tp values associated with its key
# you're done