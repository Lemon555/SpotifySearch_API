# frozen_string_literal: true

require 'json'

# Represents overall group information for JSON API output
class ErrorRepresenter < Roar::Decorator
  include Roar::JSON
  property :code
  property :message

  ERROR = {
    already_exist: 422,
    not_found_in_DB: 404,
    not_found_on_Spotify: 400,
    cannot_process: 500
  }.freeze

  def to_status_response
    [ERROR[@represented.code], { errors: [@represented.message] }.to_json]
  end
end
