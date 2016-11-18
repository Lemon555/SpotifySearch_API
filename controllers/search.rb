# frozen_string_literal: true

# GroupAPI web service
class SpotifySearchAPI < Sinatra::Base
  get "/#{API_VER}/:song_name/?" do
    results = FindSong.call(params)

    if results.success?
      SongRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  post "/#{API_VER}/:song_name/?" do
    result = LoadSongFromSpotify.call(params)

    if result.seccess?
      SongRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
