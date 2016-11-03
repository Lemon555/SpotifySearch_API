require_relative 'spec_helper'

describe 'card specifications' do
  SAD_SEARCH_INPUT = 'sdfghjk'.freeze

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end
  after do
    VCR.eject_cassette
  end

  describe 'Find albums by its track name' do
    it 'HAPPY: should find an album given a track name' do
      get "api/v0.1/track_search/#{app.config.SEARCH_INPUT}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['track']['items'].length.must_be :>, 0
    end

    it 'SAD: should report if a group is not found' do
      get "api/v0.1/track_search/#{SAD_SEARCH_INPUT}"

      last_response.status.must_equal 200
      last_response.body.must_include SAD_SEARCH_INPUT
      search_data = JSON.parse(last_response.body)
      search_data['track']['items'].length.must_be :<=, 0
    end
  end
end
