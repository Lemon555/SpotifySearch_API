# frozen_string_literal: true

# GroupAPI web service
class SpotifySearchAPI < Sinatra::Base
  get "/#{API_VER}/:song_name/?" do
    results = FindSong.call(params[:song_name])

    if results.success?
      SongsSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  post "/#{API_VER}/:song_name/?" do
    result = LoadSongFromSpotify.call(params[:song_name])

    if result.success?
      SearchRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
