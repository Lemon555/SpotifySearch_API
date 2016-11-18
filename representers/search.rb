# frozen_string_literal: true

# Represents overall search information for JSON API output
class SearchRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :input
end
