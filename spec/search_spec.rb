# frozen_string_literal: true
require_relative 'spec_helper'

describe 'search specifications' do
  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Loading and saving a new track by ID' do
    before do
      DB[:searchs].delete
      DB[:songs].delete
    end

    it '(HAPPY) should load and save a new result of search by given input' do
      post "api/v0.1/#{HAPPY_SEARCH_INPUT}",
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'input'
      body.must_include 'search_id'

      Search.count.must_equal 1
      Song.count.must_be :>=, 1
    end

    it '(BAD) should report error if given invalid input' do
      post "api/v0.1/#{SAD_SEARCH_INPUT}",
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 400
      last_response.body.must_include SAD_SEARCH_INPUT
    end

    it 'should report error if searching keyword already exists' do
      2.times do
        post "api/v0.1/#{HAPPY_SEARCH_INPUT}",
             'CONTENT_TYPE' => 'application/json'
      end

      last_response.status.must_equal 422
    end
  end

  describe 'Do a search' do
      it 'HAPPY: should find a array of album given a track name' do
        get "api/v0.1/#{HAPPY_SEARCH_INPUT}"
        last_response.status.must_equal 200
        last_response.content_type.must_equal 'application/json'
        search_data = JSON.parse(last_response.body)
        search_data.is_a?(Array)
        expect(search_data).not_to be_empty
      end

      it 'HAPPY: should find hash of images given a track name' do
      type = 'images'
      get "api/v0.1/#{HAPPY_SEARCH_INPUT}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      search_data = JSON.parse(last_response.body)
      search_data['images'].is_a?(Hash)
      end

      it 'SAD: should report if no albums are found' do
        get "api/v0.1/#{SAD_SEARCH_INPUT}"
        search_data = JSON.parse(last_response.body)
        expect(search_data).to be_empty
      end
  end

  describe 'Request to update a search' do
    after do
      DB[:searchs].delete
      DB[:songs].delete
      post "api/v0.1/#{HAPPY_SEARCH_INPUT}",
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully update valid song' do
      original = Song.count
      put "api/v0.1/#{HAPPY_SEARCH_INPUT}"
      last_response.status.must_equal 200
      updated = Song.count
      updated.must_be :>=, original
    end

    it '(BAD) should report error if given invalid search' do
      put "api/v0.1/#{SAD_SEARCH_INPUT}"
      last_response.status.must_equal 400
      last_response.body.must_include SAD_POSTING_ID
    end
  end
end
