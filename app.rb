# frozen_string_literal: true
require 'sinatra'
require 'spotifysearch'

# GroupAPI web service
class SpotifySearchAPI < Sinatra::Base
  API_VER = 'api/v0.1'

  get '/?' do
    "SpotifySearchAPI latest version endpoints are at: /#{API_VER}/"
  end

  get "/#{API_VER}/:type/:song_name/?" do
    search_type = params[:type]
    track_name = params[:song_name]
    result = {}

    begin
      search = Spotify::Search.find(track_name)
      result[search_type] = type_of_result(search_type, search)

      content_type 'application/json'
      result.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end

  def type_of_result(search_type, search)
    pick_search = {
      'tracks' => ->(key, _) { key },
      'artists' => ->(_, song) { song.artist_name },
      'albums' => ->(_, song) { song.album_name },
      'links' => ->(_, song) { song.track_link },
      'images' => ->(_, song) { song.imgs }
    }

    search.map do |key, song|
      [song.track_name, pick_search[search_type].call(key, song)]
    end.to_h
  end
end
