# frozen_string_literal: true

# configure based on environment
class SpotifySearchAPI < Sinatra::Base
  extend Econfig::Shortcut

  API_VER = 'api/v0.2'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
  end

  get '/?' do
    "SpotifySearchAPI latest version endpoints are at: /#{API_VER}/"
  end
end
