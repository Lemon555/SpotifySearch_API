# frozen_string_literal: true
require_relative 'spec_helper'

describe 'search specifications' do
  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Loading and saving a new track (Post)' do
    before do
      DB[:searches].delete
      DB[:songs].delete
    end

    it '(HAPPY) should load and save a new result of search by given input' do
      post "api/v0.1/#{HAPPY_SEARCH_INPUT}"

      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'input'
      body.must_include 'id'

      Search.count.must_equal 1
      Song.count.must_be :>=, 1
    end

    it '(BAD) should report error if given invalid input' do
      post "api/v0.1/#{SAD_SEARCH_INPUT}"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_SEARCH_INPUT
    end

    it 'should report error if searching keyword already exists' do
      2.times do
        post "api/v0.1/#{HAPPY_SEARCH_INPUT}"
      end

      last_response.status.must_equal 422
    end
  end

  describe 'Find stored searches by input(GET)' do
    before do
      DB[:searches].delete
      DB[:songs].delete
      post "api/v0.1/#{HAPPY_SEARCH_INPUT}"
    end

    it 'HAPPY: should find a array of album given a track name' do
      get "api/v0.1/#{HAPPY_SEARCH_INPUT}"
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data.is_a?(Array)
      search_data.length.must_be :>=, 1
    end

    it 'HAPPY: should find hash of images given a track name' do
      get "api/v0.1/#{HAPPY_SEARCH_INPUT}"
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['songs'][1]['images'].is_a?(Array)
    end

    it 'SAD: should report if no albums are found' do
      get "api/v0.1/#{SAD_SEARCH_INPUT}"
      last_response.status.must_equal 404
      last_response.body.must_include SAD_SEARCH_INPUT
    end
  end
end
