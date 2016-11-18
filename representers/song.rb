# frozen_string_literal: true

# Represents overall group information for JSON API output
class SongRepresenter < Roar::Decorator
  include Roar::JSON

  property :track_id
  property :search_id
  property :track_name
  property :artists
  property :album
  property :link
  property :images
end
