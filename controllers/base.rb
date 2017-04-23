# frozen_string_literal: true

require 'econfig'
require 'sinatra'

# configure based on environment
class SpotifySearchAPI < Sinatra::Base
  extend Econfig::Shortcut

  API_VER = 'api/v0.1'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    SecureDB.setup(settings.config)
  end

  after do
    content_type 'application/json'
  end

  get '/?' do
    "SpotifySearchAPI latest version endpoints are at: /#{API_VER}/".to_json
  end
end
