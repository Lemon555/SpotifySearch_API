# frozen_string_literal: true
require_relative 'spec_helper'

describe 'API basics' do
  it 'should successfully find the root route' do
    get '/'
    last_response.body.must_include 'Spotify'
    last_response.status.must_equal 200
  end
end
