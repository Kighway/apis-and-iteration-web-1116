require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  url = 'http://www.swapi.co/api/people/'

  while url
    page = JSON.parse(RestClient.get(url))
    found_character = page["results"].find { |character_hash| character_hash["name"].downcase == character }
    break if found_character
    url = page["next"]
  end

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.

  found_character["films"].collect { |url| JSON.parse(RestClient.get(url)) }
end


def parse_character_movies(film_descriptions)
  # some iteration magic and puts out the movies in a nice list
  roman_numerals = ["I", "II", "III", "IV", "V", "VI", "VII"]
   film_descriptions.each do |description_hash|
     puts "Star Wars: Episode #{roman_numerals[description_hash["episode_id"]-1]} - #{description_hash["title"]} "
     puts "Directed by #{description_hash["director"]}"
     puts "Released on #{description_hash["release_date"]}"
     puts " "
   end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
