# frozen_string_literal: true

class SpotifySearchAPI < Sinatra::Base

  post "/#{API_VER}/:song_name/?" do
    track_name = params[:song_name]

    if Group.find(input: track_name)
      halt 422, "Search (input: #{track_name})already exists"
    end

    begin
      search = Spotify::Search.find(track_name)

      content_type 'application/json'
      result.to_json
    rescue
      halt 404, "No (id: #{track_name}) found on Spotify"
    end

    begin
      group = Search.create(input: track_name)

      search.each do |key, track|
        Song.create(
          track_id: key,
          search_id: search.id,
          track_name: track.track_name,
          link: track.track_link,
          album: track.album_name,
          artists: track.artist_name,
          images: track.imgs
        )
      end
  end
