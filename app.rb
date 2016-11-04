# frozen_string_literal: true
require 'sinatra'
require 'spotifysearch'

# GroupAPI web service
class SpotifySearchAPI < Sinatra::Base
  API_VER = 'api/v0.1'.freeze

  get '/?' do
    "SpotifySearchAPI latest version endpoints are at: /#{API_VER}/"
  end

  get "/#{API_VER}/song/:song_name/?" do
    track_name = params[:song_name]
    begin
      search = Spotify::Search.find(id: track_name)

      content_type 'application/json'
      { result: search }.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end

  get "/#{API_VER}/artists/:song_name/?" do
    track_name = params[:song_name]
    begin
      search = Spotify::Search.find(id: track_name)
      artist_hash = {}
      search.each do |song|
        artist_hash[song.track_name] = song.artist_name
      end

      content_type 'application/json'
      { artists: artist_hash }.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end

  get "/#{API_VER}/albums/:song_name/?" do
    track_name = params[:song_name]
    begin
      search = Spotify::Search.find(id: track_name)
      album_hash = {}
      search.each do |song|
        album_hash[song.track_name] = song.album_name
      end

      content_type 'application/json'
      { albums: album_hash }.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end

  get "/#{API_VER}/links/:song_name/?" do
    track_name = params[:song_name]
    begin
      search = Spotify::Search.find(id: track_name)
      link_hash = {}
      search.each do |song|
        link_hash[song.track_name] = song.track_link
      end

      content_type 'application/json'
      { links: link_hash }.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end

  get "/#{API_VER}/images/:song_name/?" do
    track_name = params[:song_name]
    begin
      search = Spotify::Search.find(id: track_name)
      image_hash = {}
      search.each do |song|
        image_hash[song.track_name] = song.imgs
      end

      content_type 'application/json'
      { images: image_hash }.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end
end
