# frozen_string_literal: true

# GroupAPI web service
class SpotifySearchAPI < Sinatra::Base
  get "/#{API_VER}/:song_name/?" do
    track_name = params[:song_name]
    result_arr = []
    begin
      search = Search.find(input: track_name)
      relevant_songs = search.songs

      relevant_songs.each do |song|
        song_hash = {}
        song_hash['track_name'] = song.track_name
        song_hash['link'] = song.link
        song_hash['album'] = song.album
        song_hash['artists'] = song.artists
        song_hash['images'] = song.images
        result_arr.push(song_hash)
      end

      content_type 'application/json'
      result_arr.to_json
    rescue
      content_type 'text/plain'
      halt 404, "No (#{track_name}) found in Database"
    end
  end

  post "/#{API_VER}/:song_name/?" do
    track_name = params[:song_name]
    begin
      if Search.find(input: track_name)
        halt 422, "Search (input: #{track_name})already exists"
      end
      spotify_search = Spotify::Search.find(track_name)
      if spotify_search.keys.length.zero?
        halt 400, "No (#{track_name}) found on Spotify"
      end
    rescue
      halt 400, "No (#{track_name}) found on Spotify"
    end

    begin
      search = Search.create(input: track_name)

      spotify_search.each do |_, track|
        Song.create(
          # track_id: key,
          search_id: search.id,
          track_name: track.track_name,
          link: track.track_link,
          album: track.album_name,
          artists: track.artist_name.to_json,
          images: track.imgs.to_json
        )
      end
      content_type 'application/json'
      { id: search.id, input: search.input }.to_json
    rescue
      halt 500, "Song (#{track_name}) could not be processed"
    end
  end
end
