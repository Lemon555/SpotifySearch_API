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
    search_hash = {}
    case search_type

    when 'tracks' then
      search.each do |key, song|
        search_hash[song.track_name] = key
      end
      search_hash
    when 'artists' then
      search.each do |_, song|
        search_hash[song.track_name] = song.artist_name
      end
      search_hash
    when 'albums' then
      search.each do |_, song|
        search_hash[song.track_name] = song.album_name
      end
      search_hash
    when 'links' then
      search.each do |_, song|
        search_hash[song.track_name] = song.track_link
      end
      search_hash
    when 'images' then
      search.each do |_, song|
        search_hash[song.track_name] = song.imgs
      end
      search_hash
    end
  end
end
