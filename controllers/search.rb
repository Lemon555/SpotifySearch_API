# frozen_string_literal: true

# GroupAPI web service
class SpotifySearchAPI < Sinatra::Base
  get "/#{API_VER}/:song_name/?" do
    track_name = params[:song_name]
    result_arr = []
    begin
      search = Search.find(track_name)
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
      halt 404, "No (id: #{track_name}) found on Spotify"
    end
  end
end
