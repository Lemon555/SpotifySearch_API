# frozen_string_literal: true

# Worker web service
class SpotifySearchAPI < Sinatra::Base
  get "/#{API_VER}/:clear_DB/?" do
    results = ClearDB.call

    if results.success?
      results.value.to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
