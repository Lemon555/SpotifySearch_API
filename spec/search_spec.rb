# frozen_string_literal: true
require_relative 'spec_helper'

describe 'card specifications' do
  SAD_SEARCH_INPUT = 'sdfghjk'
  HAPPY_SEARCH_INPUT = 'Eyes+Shut'
  type = ''

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end
  after do
    VCR.eject_cassette
  end

  describe 'Do a search' do
    it 'HAPPY: should find hash of album given a track name' do
      type = 'tracks'
      get "api/v0.1/#{type}/#{HAPPY_SEARCH_INPUT}"
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['tracks'].is_a?(Hash)
    end

    it 'HAPPY: should find hash of album given a track name' do
      type = 'albums'
      get "api/v0.1/#{type}/#{HAPPY_SEARCH_INPUT}"
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['albums'].is_a?(Hash)
    end

    it 'HAPPY: should find hash of artists given a track name' do
      type = 'artists'
      get "api/v0.1/#{type}/#{HAPPY_SEARCH_INPUT}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['artists'].is_a?(Hash)
    end

    it 'HAPPY: should find hash of links given a track name' do
      type = 'links'
      get "api/v0.1/#{type}/#{HAPPY_SEARCH_INPUT}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['links'].is_a?(Hash)
    end

    it 'HAPPY: should find hash of images given a track name' do
      type = 'images'
      get "api/v0.1/#{type}/#{HAPPY_SEARCH_INPUT}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['images'].is_a?(Hash)
    end

    it 'SAD: should report if no albums are found' do
      type = 'tracks'
      get "api/v0.1/#{type}/#{SAD_SEARCH_INPUT}"
      search_data = JSON.parse(last_response.body)
      search_data['albums'].is_a?(NilClass)
    end
  end
end
